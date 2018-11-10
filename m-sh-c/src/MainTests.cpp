#include "Routing.h"

#include "RecommendationsSearcher.h"
#include "ToString.h"

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

void testOrderPlanner()
{
    GeoPoint start;
    start.set_lat(59.945541);
    start.set_lon(30.240211);

    GeoPoint finish;
    finish.set_lat(59.941504);
    finish.set_lon(30.276670);

    TimeWindow availabilityWindow;
    availabilityWindow.set_from(500);
    availabilityWindow.set_to(1000);

    SearchParams searchParams;
    searchParams.mutable_start()->CopyFrom(start);
    searchParams.mutable_finish()->CopyFrom(finish);
    searchParams.set_transport(Transport::PEDESTRIAN);
    searchParams.mutable_availabilitywindow()->CopyFrom(availabilityWindow);
    searchParams.set_timelimit(120);
    searchParams.set_distancelimit(15000);

    GeoPoint shop0;
    shop0.set_lat(59.948048);
    shop0.set_lon(30.271740);
    Location locShop0;
    locShop0.set_id(0);
    locShop0.mutable_geopoint()->CopyFrom(shop0);

    GeoPoint shop1;
    shop1.set_lat(59.943151);
    shop1.set_lon(30.261406);
    Location locShop1;
    locShop1.set_id(1);
    locShop1.mutable_geopoint()->CopyFrom(shop1);

    GeoPoint shop2;
    shop2.set_lat(59.935880);
    shop2.set_lon(30.236351);
    Location locShop2;
    locShop2.set_id(2);
    locShop2.mutable_geopoint()->CopyFrom(shop2);

    GeoPoint shelter;
    shelter.set_lat(59.941656);
    shelter.set_lon(30.273798);
    Location locShelter;
    locShelter.set_id(3);
    locShelter.mutable_geopoint()->CopyFrom(shelter);

    TimeWindow timeWindowCommon;
    timeWindowCommon.set_from(0);
    timeWindowCommon.set_to(2000);

    Demand demandShop;
    Event eventShop0;
    eventShop0.set_id(4);
    eventShop0.mutable_location()->CopyFrom(locShop0);
    eventShop0.mutable_timewindow()->CopyFrom(timeWindowCommon);
    eventShop0.set_duration(15);

    Event eventShop1;
    eventShop1.set_id(5);
    eventShop1.mutable_location()->CopyFrom(locShop1);
    eventShop1.mutable_timewindow()->CopyFrom(timeWindowCommon);
    eventShop1.set_duration(15);

    Event eventShop2;
    eventShop2.set_id(6);
    eventShop2.mutable_location()->CopyFrom(locShop2);
    eventShop2.mutable_timewindow()->CopyFrom(timeWindowCommon);
    eventShop2.set_duration(15);

    demandShop.mutable_events()->Add()->CopyFrom(eventShop0);
    demandShop.mutable_events()->Add()->CopyFrom(eventShop1);
    demandShop.mutable_events()->Add()->CopyFrom(eventShop2);

    Demand demandShelter;
    Event eventShelter;
    eventShelter.set_id(7);
    eventShelter.mutable_location()->CopyFrom(locShelter);
    eventShelter.mutable_timewindow()->CopyFrom(timeWindowCommon);
    eventShelter.set_duration(30);

    demandShelter.mutable_events()->Add()->CopyFrom(eventShelter);

    Order orderShopShelter;
    orderShopShelter.set_id(42);
    orderShopShelter.mutable_demands()->Add()->CopyFrom(demandShop);
    orderShopShelter.mutable_demands()->Add()->CopyFrom(demandShelter);

    Task task;
    task.mutable_params()->CopyFrom(searchParams);
    task.mutable_orders()->Add()->CopyFrom(orderShopShelter);

    const Recommendations recommendations = findRecommendations(task);

    std::cout << toString(recommendations) << std::endl;
}

int main()
{
    testRouting();
    testOrderPlanner();

    return 0;
}
