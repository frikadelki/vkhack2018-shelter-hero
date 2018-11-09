#pragma once

#include "HelperCommon.h"

#include "Recommendations.pb.h"

namespace sh
{
    Time time(const GeoPoint& from, const GeoPoint& to, Transport transport);
    Dist dist(const GeoPoint& from, const GeoPoint& to, Transport transport);
}
