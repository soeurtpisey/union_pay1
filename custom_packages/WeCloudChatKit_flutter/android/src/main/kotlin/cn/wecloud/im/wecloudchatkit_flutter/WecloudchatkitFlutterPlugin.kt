package cn.wecloud.im.wecloudchatkit_flutter

import android.os.Handler
import android.os.Looper
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class WecloudchatkitFlutterPlugin : FlutterPlugin {
    companion object {
        val handler = Handler(Looper.getMainLooper())
    }

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, WeClientWrapper.CHANNEL_NAME)
        channel.setMethodCallHandler(WeClientWrapper(flutterPluginBinding))
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
