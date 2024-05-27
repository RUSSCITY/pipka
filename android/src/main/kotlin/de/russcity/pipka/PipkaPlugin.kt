package de.russcity.pipka

import androidx.annotation.NonNull
import android.app.Activity
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import android.util.Log
import android.app.PictureInPictureParams
import android.app.RemoteAction
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.util.Rational
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware

/** PipkaPlugin */
class PipkaPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private val CHANNEL = "de.russcity.pipka"
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var activity: Activity? = null
    private var actions: MutableList<RemoteAction> = mutableListOf()

    private var params: PictureInPictureParams.Builder? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        Log.d(CHANNEL, "onAttachedToEngine")
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        Log.d(CHANNEL, "onMethodCall")
        if (activity == null) {
            result.error("ActivityNotInitialized", "Activity is not initialized", null)
            Log.e(CHANNEL, "Activity is not initialized")
            return
        }
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${Build.VERSION.RELEASE}")
            "isPipAvailable" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                result.success(
                    activity!!.packageManager.hasSystemFeature(PackageManager.FEATURE_PICTURE_IN_PICTURE)
                )
            } else {
                result.success(false)
            }

            "isPipActivated" -> if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
                result.success(activity!!.isInPictureInPictureMode)
            } else {
                result.success(false)
            }

            "isAutoPipAvailable" -> result.success(Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
            "enterPipMode" -> {
                val aspectRatio = call.argument<List<Int>>("aspectRatio")
                val autoEnter = call.argument<Boolean>("autoEnter")
                val seamlessResize = call.argument<Boolean>("seamlessResize")
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    var params = PictureInPictureParams.Builder()
                        .setAspectRatio(Rational(aspectRatio!![0], aspectRatio[1]))
                        .setActions(actions)
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        params = params.setAutoEnterEnabled(autoEnter!!)
                            .setSeamlessResizeEnabled(seamlessResize!!)
                    }

                    this.params = params

                    result.success(
                        activity!!.enterPictureInPictureMode(params.build())
                    )
                }
            }

            "setAutoPipMode" -> {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                    val aspectRatio = call.argument<List<Int>>("aspectRatio")
                    val autoEnter = call.argument<Boolean>("autoEnter")
                    val seamlessResize = call.argument<Boolean>("seamlessResize")
                    val params = PictureInPictureParams.Builder()
                        .setAspectRatio(Rational(aspectRatio!![0], aspectRatio[1]))
                        .setAutoEnterEnabled(autoEnter!!)
                        .setSeamlessResizeEnabled(seamlessResize!!)
                        .setActions(actions)

                    this.params = params

                    activity!!.setPictureInPictureParams(params.build())

                    result.success(true)
                } else {
                    result.error(
                        "NotImplemented",
                        "System Version less than Android S found",
                        "Expected Android S or newer."
                    )
                }
            }

            else -> result.notImplemented()
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        Log.d(CHANNEL, "onAttachedToActivity")
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        Log.d(CHANNEL, "onDetachedFromActivityForConfigChanges")
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        Log.d(CHANNEL, "onReattachedToActivityForConfigChanges")
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        Log.d(CHANNEL, "onDetachedFromActivity")
        activity = null
    }
}
