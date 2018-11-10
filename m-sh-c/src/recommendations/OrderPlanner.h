#pragma once

#include "Recommendations.pb.h"
#include "HelperCommon.h"

namespace sh
{
    Opt<Trip> planOrder(const Order& order, const SearchParams& searchParams);
}