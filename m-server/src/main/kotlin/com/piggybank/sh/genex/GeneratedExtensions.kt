package com.piggybank.sh.genex

import com.piggybank.sh.generated.GeoPoint

fun geoPoint(lat: Double, lon: Double): GeoPoint {
    return GeoPoint.newBuilder()
            .setLat(lat)
            .setLon(lon)
            .build()
}