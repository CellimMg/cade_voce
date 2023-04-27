package com.example.cade_voce


import android.util.Log
import com.example.cade_voce.location.LocationPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {

    private val locationPluginChannel = "locationChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val locationCallHandler = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, locationPluginChannel)
        locationCallHandler.setMethodCallHandler { call, result ->
            if(call.method == "getCurrentLocation"){
                val locationPlugin = LocationPlugin(this)
                val location = locationPlugin.getCurrentLocation()
                if(location != null){
                    result.success(location)
                }else{
                    result.error("UNAVAILABLE", "Location not available", null)
                }
            }else{
                result.notImplemented()
            }
        }

    }
}
