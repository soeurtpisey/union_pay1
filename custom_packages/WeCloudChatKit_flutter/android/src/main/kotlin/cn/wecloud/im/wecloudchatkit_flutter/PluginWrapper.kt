package cn.wecloud.im.wecloudchatkit_flutter

import cn.wecloud.im.exception.WeException
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.JSONMethodCodec
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import java.util.HashMap
import java.util.concurrent.Executors

open class PluginWrapper(flutterPluginBinding: FlutterPluginBinding, channelName: String) :
    MethodCallHandler {

    companion object {

        private const val CHANNEL_PREFIX = "cn.wecloud.im/"
    }

    private val cachedThreadPool = Executors.newCachedThreadPool()
    val context = flutterPluginBinding.applicationContext
    val binging = flutterPluginBinding
    val channel = MethodChannel(
        flutterPluginBinding.binaryMessenger, CHANNEL_PREFIX + channelName, JSONMethodCodec.INSTANCE
    )

    init {
        channel.setMethodCallHandler(this)
    }

    fun post(runnable: Runnable) {
        WecloudchatkitFlutterPlugin.handler.post(runnable)
    }

    fun asyncRunnable(runnable: Runnable?) {
        cachedThreadPool.execute(runnable)
    }


    fun onSuccess(result: MethodChannel.Result, channelName: String, `object`: Any?) {
        post(Runnable {
            val data: MutableMap<String, Any> =
                HashMap()
            if (`object` != null) {
                data[channelName] = `object`
            }
            result.success(data)
        })
    }

    fun onError(result: MethodChannel.Result, e: WeException) {
        post(Runnable {
            val data: MutableMap<String, Any> =
                HashMap()
            data["error"] = e.toMap()
            result.success(data)
        })
    }


    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        result.notImplemented()
    }

}