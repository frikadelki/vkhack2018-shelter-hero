package com.piggybank.sh.genex

import com.piggybank.sh.generated.GeoPoint
import com.piggybank.sh.generated.Location
import com.piggybank.sh.generated.TimeWindow

typealias Duration = Int // in minutes

fun geoPointOf(lat: Double, lon: Double): GeoPoint {
    return GeoPoint.newBuilder()
            .setLat(lat)
            .setLon(lon)
            .build()
}

fun timeWindowOf(from: Duration, to: Duration): TimeWindow {
    return TimeWindow.newBuilder()
            .setFrom(from)
            .setTo(to)
            .build()
}

fun locationOf(point: GeoPoint): Location {
    return Location.newBuilder()
            .setId(0)
            .setGeoPoint(point)
            .build()
}