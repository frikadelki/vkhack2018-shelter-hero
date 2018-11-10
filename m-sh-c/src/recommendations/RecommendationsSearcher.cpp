#include "RecommendationsSearcher.h"

#include "OrderPlanner.h"

namespace sh
{
    Recommendations findRecommendations(const Task& task)
    {
        Recommendations recommendations;

        for (const Order& order : task.orders())
        {
            const Opt<Trip> trip = planOrder(order, task.params());
            if (trip)
            {
                recommendations.mutable_recommendations()->Add()->CopyFrom(trip.value());
            }
        }

        return recommendations;
    }
}
