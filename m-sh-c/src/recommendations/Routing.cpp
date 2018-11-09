#include "Routing.h"

#include <cmath>
#include <cassert>

namespace sh
{
    namespace
    {
        using Velocity = double; // meters per minute

        Velocity velocity(const Transport transport)
        {
            switch (transport)
            {
                case Transport::PEDESTRIAN: return 83; // 5 km / h
                case Transport::PUBLIC_TRANSPORT: return 333; // 20 km / h
                case Transport::CAR: return 666; // 40 km / h
            }

            assert(false);
        }

        double toRadians(const double degree)
        {
            constexpr double PI = 3.14159265359;
            return degree * PI / 180;
        }
    }

    Time time(const GeoPoint& from, const GeoPoint& to, const Transport transport)
    {
        return dist(from, to, transport) / velocity(transport);
    }

    Dist dist(const GeoPoint& from, const GeoPoint& to, const Transport /*transport*/)
    {
        using namespace std;

        constexpr double EARTH_RADIUS = 6371008; // m

        const double lat1 = toRadians(from.lat());
        const double lat2 = toRadians(to.lat());
        const double dlon = toRadians(abs(from.lon() - to.lon()));

        const double angleDelta = acos
        (
              sin(lat1) * sin(lat2)
            + cos(lat1) * cos(lat2) * cos(dlon)
        );

        return EARTH_RADIUS * angleDelta;
    }
}
