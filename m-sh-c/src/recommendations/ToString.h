#pragma once

#include "Recommendations.pb.h"
#include "HelperCommon.h"

#include <string>

namespace sh
{
    std::string toString(const Trip& trip);
    std::string toString(const Task& task);
    std::string toString(const Recommendations& recommendations);
}
