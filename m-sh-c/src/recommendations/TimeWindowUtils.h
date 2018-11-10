#pragma once

#include "Recommendations.pb.h"
#include "HelperCommon.h"

namespace sh
{
    bool in(const Time time, const TimeWindow& timeWindow);

    bool fits(Time start, Time duration, const TimeWindow& timeWindow);
}
