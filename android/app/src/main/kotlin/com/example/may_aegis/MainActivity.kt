package com.example.may_aegis

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.MethodCall
import android.content.pm.PackageManager
import android.provider.Settings
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.core.content.ContextCompat
import android.content.pm.ApplicationInfo
import android.os.Build
import android.provider.MediaStore
import androidx.annotation.RequiresApi
import android.util.Log

class MainActivity: FlutterActivity(), MethodCallHandler {
    private val CHANNEL = "com.example.permission_manager/permissions"
    private lateinit var methodChannel: MethodChannel
    private lateinit var dbHelper: PermissionUsageDBHelper

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getAppsWithPermission" -> {
                val permission = call.argument<String>("permission")
                if (permission != null) {
                    result.success(getAppsWithPermission(permission))
                } else {
                    result.error("INVALID_PERMISSION", "Permission type is required", null)
                }
            }
            "openAppSettings" -> {
                val packageName = call.argument<String>("packageName")
                if (packageName != null) {
                    openAppSettings(packageName)
                    result.success(true)
                } else {
                    result.error("INVALID_PACKAGE", "Package name is required", null)
                }
            }
            "getResourceUsageDistribution" -> {
                try {
                    result.success(dbHelper.getResourceUsageDistribution())
                } catch (e: Exception) {
                    result.error("ERROR", "Failed to get resource usage distribution", e.message)
                }
            }
            "getDailyUsage" -> {
                try {
                    result.success(dbHelper.getDailyUsage())
                } catch (e: Exception) {
                    result.error("ERROR", "Failed to get daily usage", e.message)
                }
            }
            "getMostActiveDays" -> {
                try {
                    result.success(dbHelper.getMostActiveDays())
                } catch (e: Exception) {
                    result.error("ERROR", "Failed to get most active days", e.message)
                }
            }
            else -> result.notImplemented()
        }
    }

   private fun getAppsWithPermission(permissionType: String): List<Map<String, Any>> {
    val pm = applicationContext.packageManager
    val apps = mutableListOf<Map<String, Any>>()

    val intentAction = when (permissionType) {
        "android.permission.CAMERA" -> Intent(MediaStore.ACTION_IMAGE_CAPTURE)
        "android.permission.RECORD_AUDIO" -> Intent(MediaStore.Audio.Media.RECORD_SOUND_ACTION)
        "android.permission.ACCESS_FINE_LOCATION" -> Intent(Intent.ACTION_VIEW, Uri.parse("geo:0,0"))
        else -> return apps
    }

    val resolveInfos = pm.queryIntentActivities(intentAction, PackageManager.MATCH_DEFAULT_ONLY)

    for (resolveInfo in resolveInfos) {
        try {
            val packageName = resolveInfo.activityInfo.packageName
            // Get applicationInfo safely
            val applicationInfo = pm.getApplicationInfo(packageName, 0)

            // Check if applicationInfo is null
            if (applicationInfo != null) {
                val hasPermission = checkPermissionForApp(packageName, permissionType)

                val appLabel = try {
                    pm.getApplicationLabel(applicationInfo).toString()
                } catch (e: Exception) {
                    packageName // Fallback to package name if label can't be retrieved
                }

                apps.add(mapOf(
                    "packageName" to packageName,
                    "appName" to appLabel,
                    "hasPermission" to hasPermission,
                    "isSystemApp" to ((applicationInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0)
                ))
            }
        } catch (e: Exception) {
            Log.e("MainActivity", "Error processing app: $e")
        }
    }

    return apps
}


    private fun checkPermissionForApp(packageName: String, permission: String): Boolean {
        val granted = try {
            val packageInfo = packageManager.getPackageInfo(packageName, 0)
            val appName = packageInfo.applicationInfo?.let { packageManager.getApplicationLabel(it).toString() }
            
            val permissionCheck = ContextCompat.checkSelfPermission(this, permission)
            val isGranted = permissionCheck == PackageManager.PERMISSION_GRANTED

            if (appName != null) {
                dbHelper.recordPermissionUsage(permission, packageName, appName, isGranted)
            }
            
            isGranted
        } catch (e: Exception) {
            false
        }
        return granted
    }

    private fun openAppSettings(packageName: String) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        intent.data = Uri.fromParts("package", packageName, null)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        dbHelper = PermissionUsageDBHelper(applicationContext)
    }
}