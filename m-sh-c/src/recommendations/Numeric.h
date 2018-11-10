#pragma once

namespace sh
{
    constexpr double EPS = 1E-5;

    bool less(double a, double b, double eps = EPS);
    bool greater(double a, double b, double eps = EPS);
    bool equal(double a, double b, double eps = EPS);
    bool lessEqual(double a, double b, double eps = EPS);
    bool greaterEqual(double a, double b, double eps = EPS);

    double max(double a, double b);
}
