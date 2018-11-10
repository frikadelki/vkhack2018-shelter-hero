#include "OrderPlanner.h"

#include "Routing.h"
#include "TimeWindowUtils.h"
#include "Numeric.h"

#include <vector>
#include <algorithm>

namespace sh
{
    namespace
    {
        struct DpState
        {
            DpState()
                : start(TIME_INF)
                , finish(TIME_INF)
                , dist(TIME_INF)
                , prevDpState(std::nullopt)
                , prevEvent(std::nullopt)
            {
            }

            bool valid() const
            {
                return (TIME_INF != start)
                    && (TIME_INF != finish)
                    && (DIST_INF != dist);
            }

            Time start;
            Time finish;

            Dist dist;

            OptRef<const DpState> prevDpState;
            OptRef<const Event> prevEvent;
        };

        using DpStates = std::vector<DpState>;

        void fixDist(Dist& dist, const Dist limit)
        {
            if (greater(dist, limit))
            {
                dist = DIST_INF;
            }
        }

        void fixTime(Time& time, const Time timeStart, const Time limit)
        {
            assert(lessEqual(time, timeStart));

            if (greater(time - timeStart, limit))
            {
                time = TIME_INF;
            }
        }

        void fixTime(Time& time, const TimeWindow& timeWindow)
        {
            if (not in(time, timeWindow))
            {
                time = TIME_INF;
            }
        }

        void relaxFirstLayer(const SearchParams& searchParams, const Demand& toDemand, DpStates& toStates)
        {
            const int eventsNumber = toDemand.events_size();
            toStates.resize(eventsNumber);

            for (int i = 0; i < eventsNumber; ++i)
            {
                const Event& event = toDemand.events(i);
                DpState& state = toStates[i];

                state.start = searchParams.availabilitywindow().from()
                    + calcTime(searchParams.start(), event.location().geopoint(), searchParams.transport());
                state.start = max(state.start, event.timewindow().from());

                state.finish = state.start + event.duration();
                state.dist = calcDist(searchParams.start(), event.location().geopoint(), searchParams.transport());

                fixTime(state.start, event.timewindow());
                fixTime(state.finish, event.timewindow());

                fixTime(state.start, searchParams.availabilitywindow().from(), searchParams.timelimit());
                fixTime(state.finish, searchParams.availabilitywindow().from(), searchParams.timelimit());
                fixDist(state.dist, searchParams.distancelimit());
            }
        }

        void relaxIntermediateLayer
        (
              const SearchParams& searchParams
            , const Demand& fromDemand, const DpStates& fromStates
            , const Demand& toDemand, DpStates& toStates
        )
        {
            const int toEventsNumber = toDemand.events_size();
            const int fromEventsNumber = fromDemand.events_size();

            toStates.resize(toEventsNumber);

            for (int to = 0; to < toEventsNumber; ++to)
            {
                const Event& toEvent = toDemand.events(to);
                DpState& toState = toStates[to];

                for (int from = 0; from < fromEventsNumber; ++from)
                {
                    const Event& fromEvent = fromDemand.events(from);
                    const DpState& fromState = fromStates[from];

                    Time start = fromState.finish
                        + calcTime(fromEvent.location().geopoint(), toEvent.location().geopoint(), searchParams.transport());
                    start = max(start, toEvent.timewindow().from());

                    Time finish = start + toEvent.duration();
                    Dist dist = calcDist(fromEvent.location().geopoint(), toEvent.location().geopoint(), searchParams.transport());

                    fixTime(start, toEvent.timewindow());
                    fixTime(finish, toEvent.timewindow());

                    fixTime(start, searchParams.availabilitywindow().from(), searchParams.timelimit());
                    fixTime(finish, searchParams.availabilitywindow().from(), searchParams.timelimit());
                    fixDist(dist, searchParams.distancelimit());

                    // TODO Use better comparator
                    if (less(finish, toState.finish))
                    {
                        toState.start = start;
                        toState.finish = finish;
                        toState.dist = dist;
                        toState.prevDpState = fromState;
                        toState.prevEvent = fromEvent;
                    }
                }
            }
        }

        void relaxLastLayer
        (
              const SearchParams& searchParams
            , const Demand& fromDemand, const DpStates& fromStates
            , DpStates& toStates
        )
        {
            const int fromEventsNumber = fromDemand.events_size();

            toStates.resize(1);
            DpState& toState = toStates[0];

            for (int from = 0; from < fromEventsNumber; ++from)
            {
                const Event& fromEvent = fromDemand.events(from);
                const DpState& fromState = fromStates[from];

                Time start = fromState.finish
                    + calcTime(fromEvent.location().geopoint(), searchParams.finish(), searchParams.transport());
                Time finish = toState.start;
                Dist dist = calcDist(fromEvent.location().geopoint(), searchParams.finish(), searchParams.transport());

                fixTime(start, searchParams.availabilitywindow().from(), searchParams.timelimit());
                fixTime(finish, searchParams.availabilitywindow().from(), searchParams.timelimit());
                fixDist(dist, searchParams.distancelimit());

                // TODO Use better comparator
                if (less(finish, toState.finish))
                {
                    toState.start = start;
                    toState.finish = finish;
                    toState.dist = dist;
                    toState.prevDpState = fromState;
                    toState.prevEvent = fromEvent;
                }
            }
        }
    }

    Opt<Trip> planOrder(const Order& order, const SearchParams& searchParams)
    {
        const int demandsNumber = order.demands_size();
        assert(0 != demandsNumber);

        std::vector<DpStates> demandsDpStates(demandsNumber + 1);

        relaxFirstLayer(searchParams, order.demands(0), demandsDpStates[0]);

        for (int i = 0; i + 1 < demandsNumber; ++i)
        {
            relaxIntermediateLayer
            (
                  searchParams
                , order.demands(i), demandsDpStates[i]
                , order.demands(i + 1), demandsDpStates[i + 1]
            );
        }

        relaxLastLayer(searchParams, order.demands(demandsNumber - 1), demandsDpStates[demandsNumber - 1], demandsDpStates[demandsNumber]);

        const DpState lastState = demandsDpStates[demandsNumber][0];
        if (not lastState.valid())
        {
            return std::nullopt;
        }

        Stats stats;
        stats.set_timespent(lastState.finish);
        stats.set_distancetraveled(lastState.dist);

        Trip trip;

        trip.set_orderid(order.id());
        trip.mutable_start()->CopyFrom(searchParams.start());
        trip.mutable_finish()->CopyFrom(searchParams.finish());
        trip.mutable_stats()->CopyFrom(stats);

        std::vector<Action> actions;
        OptRef<const DpState> state = lastState.prevDpState;
        OptRef<const Event> event = lastState.prevEvent;
        while (event)
        {
            Action action;
            action.set_eventid(event->get().id());
            action.set_timestart(state->get().start);
            action.set_timefinish(state->get().finish);
            action.set_distancetraveled(state->get().dist);

            actions.emplace_back(std::move(action));

            event = state->get().prevEvent;
            state = state->get().prevDpState;
        }

        std::reverse(begin(actions), end(actions));
        for (const Action& action : actions)
        {
            trip.mutable_actions()->Add()->CopyFrom(action);
        }

        return trip;
    }
}