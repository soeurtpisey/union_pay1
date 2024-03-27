package cn.wecloud.im.wecloudchatkit_flutter

import cn.wecloud.im.core.im.IMClient
import cn.wecloud.im.core.im.IMMessageManager
import cn.wecloud.im.core.im.OnFriendEventListener
import cn.wecloud.im.core.im.callback.ICallback
import cn.wecloud.im.exception.WeException
import cn.wecloud.im.wecloudchatkit_flutter.utils.toBeanList
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject
import java.util.HashMap

class WeFriendManagerWrapper(
    flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PluginWrapper(flutterPluginBinding, CHANNEL_NAME), MethodChannel.MethodCallHandler {
    companion object {
        const val CHANNEL_NAME = "friend_manager"
    }

    init {
        registerListener()
    }

    private fun registerListener() {
        //注册好友事件监听
        IMMessageManager.registerFriendEvent(object : OnFriendEventListener(){
            override fun onApplyFriendEvent(friendClientId: String?, requestRemark: String?) {
                val data: MutableMap<String, Any> = HashMap()
                data["friendClientId"] = friendClientId?:""
                data["requestRemark"] = requestRemark?:""
                post { channel.invokeMethod(WeSDKMethod.onApplyFriendEvent, data) }
            }

            override fun onApproveFriendEvent(
                friendClientId: String?,
                agree: Boolean,
                rejectRemark: String?
            ) {
                val data: MutableMap<String, Any> = HashMap()
                data["friendClientId"] = friendClientId?:""
                data["agree"] = agree
                data["rejectRemark"] = rejectRemark?:""
                post { channel.invokeMethod(WeSDKMethod.onApproveFriendEvent, data) }
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val param = call.arguments as JSONObject
        try {
            when (call.method) {
                //申请添加好友
                WeSDKMethod.applyFriend -> applyFriend(
                    param, WeSDKMethod.applyFriend, result
                )
                //接受/拒绝好友申请
                WeSDKMethod.approveFriend -> approveFriend(
                    param, WeSDKMethod.approveFriend, result
                )
                //删除好友
                WeSDKMethod.batchDeleteFriend -> batchDeleteFriend(
                    param, WeSDKMethod.batchDeleteFriend, result
                )
            }
        }catch (ignored: JSONException) {

        }
    }

    //删除好友
    private fun batchDeleteFriend(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val friendClientIds = param.getString("friendClientIds").toBeanList<String>()
        IMClient.getInstance()
            .batchDeleteFriend(friendClientIds, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //接受/拒绝好友申请
    private fun approveFriend(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val friendClientId = param.getString("friendClientId")
        val rejectRemark = param.getString("rejectRemark")
        val agree = param.getBoolean("agree")
        IMClient.getInstance()
            .approveFriend(agree, friendClientId, rejectRemark, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //申请添加好友
    private fun applyFriend(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val friendClientId = param.getString("friendClientId")
        val remark = param.getString("remark")
        IMClient.getInstance()
            .applyFriend(friendClientId, null, remark, object : ICallback<Boolean>() {
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