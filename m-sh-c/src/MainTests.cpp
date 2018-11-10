#include "Routing.h"

#include <iostream>

using namespace sh;

void testRouting()
{
    GeoPoint p1;
    p1.set_lat(40.7486);
    p1.set_lon(73.9864);

    GeoPoint p2;
    p2.set_lat(45.7486);
    p2.set_lon(70.9864);

    // approx. 606634 m
    std::cout << calcDist(p1, p2, Transport::PEDESTRIAN) << std::endl;
}

int main()
{
    testRouting();

    return 0;
}
