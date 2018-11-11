#include "RecommendationsSearcher.h"

#include "OrderPlanner.h"

#include <tuple>
#include <algorithm>

namespace sh
{
    Recommendations findRecommendations(const Task& task)
    {

        std::vector<Trip> trips;
        for (const Order& order : task.orders())
        {
            const Opt<Trip> trip = planOrder(order, task.params());
            if (trip)
            {
                trips.emplace_back(trip.value());
            }
        }

        sort(begin(trips), end(trips), [](const Trip& lhs, const Trip& rhs)
        {
            return std::pair(lhs.stats().timespent(), lhs.stats().distancetraveled())
                <  std::pair(rhs.stats().timespent(), rhs.stats().distancetraveled());
        });

        Recommendations recommendations;
        for (const Trip& trip : trips)
        {
            recommendations.mutable_recommendations()->Add()->CopyFrom(trip);
        }

        return recommendations;
    }
}
