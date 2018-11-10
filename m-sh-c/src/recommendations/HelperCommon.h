#pragma once

#include <functional>
#include <numeric>
#include <optional>

namespace sh
{
    namespace generated
    {
    }

    using namespace generated;

    using Time = double; // minutes
    using Dist = double; // meters

    template <typename T>
    using Ref = std::reference_wrapper<T>;

    template <typename T>
    using Opt = std::optional<T>;

    template <typename T>
    using OptRef = Opt<Ref<T>>;

    constexpr Time TIME_INF = std::numeric_limits<Time>::infinity();
    constexpr Dist DIST_INF = std::numeric_limits<Dist>::infinity();
}
