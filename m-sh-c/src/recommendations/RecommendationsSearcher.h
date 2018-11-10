#pragma once

#include "Recommendations.pb.h"
#include "HelperCommon.h"

namespace sh
{
    Recommendations findRecommendations(const Task& task);
}
