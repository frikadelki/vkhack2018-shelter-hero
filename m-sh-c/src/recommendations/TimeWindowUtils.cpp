#include "TimeWindowUtils.h"

#include "Numeric.h"

namespace sh
{
    bool in(const Time time, const TimeWindow& timeWindow)
    {
        return lessEqual(timeWindow.from(), time)
            && lessEqual(time, timeWindow.to());
    }

    bool fits(const Time start, const Time duration, const TimeWindow& timeWindow)
    {
        return in(start, timeWindow)
            && in(start + duration, timeWindow);
    }
}
