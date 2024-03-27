package cn.wecloud.im.wecloudchatkit_flutter

import cn.wecloud.im.core.http.model.RTCChannel
import cn.wecloud.im.core.im.*
import cn.wecloud.im.core.im.callback.ICallback
import cn.wecloud.im.core.im.messages.Command
import cn.wecloud.im.core.im.messages.RTCEvent
import cn.wecloud.im.exception.WeException
import cn.wecloud.im.wecloudchatkit_flutter.utils.toBeanList
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject

class WeSingRtcWrapper(
    flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PluginWrapper(flutterPluginBinding, CHANNEL_NAME), MethodChannel.MethodCallHandler {
    companion object {
        const val CHANNEL_NAME = "sing_rtc_manager"
    }

    init {
        registerListener()
    }

    private fun registerListener() {
        IMMessageManager.registerRTCMessageHandler(object : IMRTCHandler() {

            override fun processCallEvent(conversation: IMConversation?, event: RTCEvent?) {
                post { channel.invokeMethod(WeSDKMethod.onProcessCallEvent, event?.toMap()) }
            }

            override fun processJoinEvent(conversation: IMConversation?, event: RTCEvent?) {
                post { channel.invokeMethod(WeSDKMethod.onProcessJoinEvent, event?.toMap()) }
            }

            override fun processLeaveEvent(conversation: IMConversation?, event: RTCEvent?) {
                post { channel.invokeMethod(WeSDKMethod.onProcessLeaveEvent, event?.toMap()) }
            }

            override fun processRejectEvent(conversation: IMConversation?, event: RTCEvent?) {
                post { channel.invokeMethod(WeSDKMethod.onProcessRejectEvent, event?.toMap()) }
            }

            override fun processSdpEvent(conversation: IMConversation?, event: RTCEvent?) {
                post { channel.invokeMethod(WeSDKMethod.onProcessSdpEvent, event?.toMap()) }
            }

            override fun processCandidateEvent(conversation: IMConversation?, event: RTCEvent?) {
                post { channel.invokeMethod(WeSDKMethod.onProcessCandidateEvent, event?.toMap()) }
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val param = call.arguments as JSONObject
        try {
            when (call.method) {
                //创建频道,并邀请客户端加入
                WeSDKMethod.createAndCall -> createAndCall(
                    param, WeSDKMethod.createAndCall, result
                )
                //同意进入频道
                WeSDKMethod.joinRtcChannel -> joinRtcChannel(
                    param, WeSDKMethod.joinRtcChannel, result
                )
                //拒接进入频道
                WeSDKMethod.rejectRtcCall -> rejectRtcCall(
                    param, WeSDKMethod.rejectRtcCall, result
                )
                //SDP数据转发
                WeSDKMethod.sdpForward -> sdpForward(
                    param, WeSDKMethod.sdpForward, result
                )
                //candidate候选者数据转发
                WeSDKMethod.candidateForward -> candidateForward(
                    param, WeSDKMethod.candidateForward, result
                )
                //主动挂断(离开频道)
                WeSDKMethod.leaveRtcChannel -> leaveRtcChannel(
                    param, WeSDKMethod.leaveRtcChannel, result
                )
            }
        } catch (ignored: JSONException) {

        }
    }

    //创建频道,并邀请客户端加入
    private fun createAndCall(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val toClient = param.getString("toClient")
        val attrsJson = param.getString("attrs")
        val attrs = Gson().fromJson<Map<String, String>>(
            attrsJson, object : TypeToken<Map<String, String>>() {}.type
        )
        val callTypeCode = param.getInt("callType")
        val callType = Command.WeRtcType.getType(callTypeCode)
        val conversationId = param.getLong("conversationId")
        val push = param.getString("push")
        val pushCall = param.getBoolean("pushCall")
        IMClient.getInstance()
            .createAndCall(
                toClient, attrs, callType, conversationId, push, pushCall,
                object : ICallback<RTCChannel>() {
                    override fun internalDone0(t: RTCChannel?, weException: WeException?) {
                        if (weException != null) {
                            onError(result, weException)
                        } else {
                            val channelId = t?.channelId
                            onSuccess(result, channelName,channelId)
                        }
                    }
                })
    }

    //创建频道,并邀请客户端加入
    private fun joinRtcChannel(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val channelId = param.getLong("channelId")
        IMClient.getInstance()
            .joinRtcChannel(channelId, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //创建频道,并邀请客户端加入
    private fun rejectRtcCall(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val channelId = param.getLong("channelId")
        IMClient.getInstance()
            .rejectRtcCall(channelId, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //创建频道,并邀请客户端加入
    private fun sdpForward(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val channelId = param.getLong("channelId")
        val sdpData = param.getString("sdpData")
        val sdpType = param.getString("sdpType")
        IMClient.getInstance()
            .sdpForward(channelId, sdpData, sdpType, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //创建频道,并邀请客户端加入
    private fun candidateForward(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val channelId = param.getLong("channelId")
        val candidateData = param.getString("candidateData")
        IMClient.getInstance()
            .candidateForward(channelId, candidateData, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //创建频道,并邀请客户端加入
    private fun leaveRtcChannel(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val channelId = param.getLong("channelId")
        IMClient.getInstance()
            .leaveRtcChannel(channelId, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

}