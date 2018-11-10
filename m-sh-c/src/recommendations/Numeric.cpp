#include "Numeric.h"

namespace sh
{
    bool less(double a, double b, double eps)
    {
        return a + eps < b;
    }
    
    bool greater(double a, double b, double eps)
    {
        return less(b, a, eps);
    }

    bool equal(double a, double b, double eps)
    {
        return not less(a, b, eps)
            && not less(b, a, eps);
    }

    bool lessEqual(double a, double b, double eps)
    {
        return not greater(a, b, eps);
    }

    bool greaterEqual(double a, double b, double eps)
    {
        return not less(a, b, eps);
    }

    double max(const double a, const double b)
    {
        return (a > b)
            ? a
            : b;
    }
}
