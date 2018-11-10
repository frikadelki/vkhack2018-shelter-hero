package com.piggybank.sh.genex

import com.piggybank.sh.generated.GeoPoint

typealias Duration = Int // in minutes

fun geoPoint(lat: Double, lon: Double): GeoPoint {
    return GeoPoint.newBuilder()
            .setLat(lat)
            .setLon(lon)
            .build()
}