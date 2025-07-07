package com.nicxonsolutions.device_apps_plus

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.content.pm.PackageManager

class DeviceAppsPlusPlugin : FlutterPlugin, MethodCallHandler {
  private lateinit var channel: MethodChannel
  private lateinit var packageManager: PackageManager

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(binding.binaryMessenger, "device_apps_plus")
    channel.setMethodCallHandler(this)
    packageManager = binding.applicationContext.packageManager
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
