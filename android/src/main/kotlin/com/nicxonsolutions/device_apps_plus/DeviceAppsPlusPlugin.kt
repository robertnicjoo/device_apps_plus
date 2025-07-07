package com.nicxonsolutions.device_apps_plus

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class DeviceAppsPlusPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var context: Context
  private lateinit var packageManager: PackageManager

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    context = binding.applicationContext
    packageManager = context.packageManager
    channel = MethodChannel(binding.binaryMessenger, "device_apps_plus")
    channel.setMethodCallHandler(this)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "getPlatformVersion" -> {
        result.success("Android ${android.os.Build.VERSION.RELEASE}")
      }
      "isAppInstalled" -> {
        val pkg = call.argument<String>("package")
        if (pkg != null) {
          result.success(isInstalled(pkg))
        } else {
          result.error("INVALID_ARGUMENT", "Package name is null", null)
        }
      }
      "checkMultiple" -> {
        val packages = call.argument<List<String>>("packages")
        val resultMap = mutableMapOf<String, Boolean>()
        packages?.forEach { pkg ->
          resultMap[pkg] = isInstalled(pkg)
        }
        result.success(resultMap)
      }
      "openApp" -> {
        val packageName = call.argument<String>("package")
        if (packageName == null) {
          result.error("INVALID_ARGUMENT", "Missing 'package'", null)
          return
        }

        val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
        if (launchIntent != null) {
          launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
          context.startActivity(launchIntent)
          result.success(true)
        } else {
          result.success(false)
        }
      }
      else -> result.notImplemented()
    }
  }

  private fun isInstalled(packageName: String): Boolean {
    return try {
      packageManager.getPackageInfo(packageName, PackageManager.GET_ACTIVITIES)
      true
    } catch (e: PackageManager.NameNotFoundException) {
      false
    }
  }
}
