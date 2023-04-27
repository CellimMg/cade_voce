package com.example.cade_voce.location

import android.Manifest

import android.app.Activity

import android.content.Context
import android.content.pm.PackageManager
import android.content.Intent
import android.provider.Settings

import android.location.Location
import android.location.LocationManager
import android.location.LocationListener



import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat

//This plugin is responsible for getting the current location of the device
class LocationPlugin (private val context: Context) {

    private val locationListener = LocationListener { }

    fun getCurrentLocation(): Map<String, Any?>? {
        val locationManager = context.getSystemService(Context.LOCATION_SERVICE) as LocationManager
        if(ContextCompat.checkSelfPermission(context, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED){
            locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, REQUEST_LOCATION_TIME, REQUEST_LOCATION_DISTANCE, locationListener)
            val lastKnownLocation: Location? = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
            return locationToMap(lastKnownLocation!!)
        }else{
            ActivityCompat.requestPermissions(context as Activity,
                arrayOf(Manifest.permission.ACCESS_FINE_LOCATION),
                REQUEST_LOCATION_CODE)
            return null
        }
    }

    private fun enableGPS(context: Context, locationManager: LocationManager) {
        if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER)) {
            val intent = Intent(Settings.ACTION_LOCATION_SOURCE_SETTINGS)
            context.startActivity(intent)
        }
    }

    private fun locationToMap(location: Location): Map<String, Any?> {
        return mapOf(
            "latitude" to location.latitude,
            "longitude" to location.longitude
        )
    }

    companion object {
        private const val REQUEST_LOCATION_CODE: Int = 1
        private const val REQUEST_LOCATION_TIME: Long = 0
        private const val REQUEST_LOCATION_DISTANCE: Float = 0.0f
    }
}


