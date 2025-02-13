package com.example.may_aegis

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.content.pm.PackageManager
import android.provider.Settings
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import androidx.core.content.ContextCompat
import android.content.pm.ApplicationInfo
import android.provider.MediaStore

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.permission_manager/permissions"
    private lateinit var methodChannel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel.setMethodCallHandler { call, result ->
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
                else -> result.notImplemented()
            }
        }
    }

    private fun getAppsWithPermission(permissionType: String): List<Map<String, Any>> {
        val pm = applicationContext.packageManager
        val apps = mutableListOf<Map<String, Any>>()

        // Get all packages based on specific intent actions
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
                val applicationInfo = pm.getApplicationInfo(packageName, 0)
                val hasPermission = checkPermissionForApp(packageName, permissionType)

                // Get app icon as bytes
                val icon = try {
                    applicationInfo.loadIcon(pm)
                    // Convert drawable to bytes if needed
                    null // Placeholder for icon conversion
                } catch (e: Exception) {
                    null
                }

                val isSystemApp = (applicationInfo.flags and ApplicationInfo.FLAG_SYSTEM) != 0

                apps.add(
                    mapOf(
                        "packageName" to packageName,
                        "appName" to pm.getApplicationLabel(applicationInfo).toString(),
                        "hasPermission" to hasPermission,
                        "isSystemApp" to isSystemApp //Use the boolean value directly
                    )
                )
            } catch (e: Exception) {
                e.printStackTrace()
            }
        }

        return apps
    }

    private fun checkPermissionForApp(packageName: String, permission: String): Boolean {
        return try {
            val granted = ContextCompat.checkSelfPermission(this, permission)
            granted == PackageManager.PERMISSION_GRANTED
        } catch (e: Exception) {
            false
        }
    }

    private fun openAppSettings(packageName: String) {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        intent.data = Uri.fromParts("package", packageName, null)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        startActivity(intent)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }
}