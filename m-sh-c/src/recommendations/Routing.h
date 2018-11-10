#pragma once

#include "HelperCommon.h"

#include "Recommendations.pb.h"

namespace sh
{
    Time calcTime(const GeoPoint& from, const GeoPoint& to, Transport transport);
    Dist calcDist(const GeoPoint& from, const GeoPoint& to, Transport transport);
}
