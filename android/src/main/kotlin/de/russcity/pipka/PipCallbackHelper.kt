package de.russcity.pipka


import android.util.Log
import androidx.annotation.NonNull
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine


open class PipCallbackHelper {
    private val CHANNEL = "de.russcity.pipka"
    private lateinit var channel: MethodChannel

    fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        Log.d(CHANNEL, "configureFlutterEngine")
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    fun onPictureInPictureModeChanged(active: Boolean) {
        Log.d(CHANNEL, "onPictureInPictureModeChanged: $active")

        if (active) {
            channel.invokeMethod("onPipEntered", null)
        } else {
            channel.invokeMethod("onPipExited", null)
        }
    }

}