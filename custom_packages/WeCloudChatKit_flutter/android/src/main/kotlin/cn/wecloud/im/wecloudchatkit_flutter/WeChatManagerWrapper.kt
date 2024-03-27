package cn.wecloud.im.wecloudchatkit_flutter

import android.util.Log
import cn.wecloud.im.core.db.entity.WeFileMsgInfo
import cn.wecloud.im.callback.IMMesssageCallback
import cn.wecloud.im.core.db.entity.WeMessage
import cn.wecloud.im.core.http.model.PageResponse
import cn.wecloud.im.core.im.*
import cn.wecloud.im.core.im.callback.ICallback
import cn.wecloud.im.exception.WeException
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject
import java.util.HashMap

class WeChatManagerWrapper(
    flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PluginWrapper(flutterPluginBinding, CHANNEL_NAME), MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "chat_manager"
    }

    init {
        registerListener()
    }

    private fun registerListener() {
        //注册默认消息处理（消息状态更新和消息接收）
        IMMessageManager.registerDefaultMessageHandler(object : MessageHandler() {
            override fun onMessageStatusUpdate(
                conversation: IMConversation?,
                messages: WeMessage?
            ) {
                post { channel.invokeMethod(WeSDKMethod.onMessageStatusUpdate, messages?.toMap()) }
            }

            override fun onMessageReceived(conversation: IMConversation?, messages: WeMessage?) {
                Log.e("onMessageReceived", "$messages")
                post { channel.invokeMethod(WeSDKMethod.onMessageReceived, messages?.toMap()) }
            }
        })
        IMMessageManager.addConvSyncStatusListener {
            post { channel.invokeMethod(WeSDKMethod.OnConvSyncStatusComplete, "") }
        }
//        IMMessageManager.setDefaultMsgBeforeSendHandler(object : MessageBeforeHandler() {
//            override fun processEvent0(
//                conversation: IMConversation?,
//                message: WeMessage?,
//                callback: Callback<WeMessage>?
//            ) {
//                val data: MutableMap<String, Any> = HashMap()
//                data["conversation"] = conversation?.info?.toMap() ?: return
//                data["message"] = message?.toMap() ?: return
//                post {
//                    channel.invokeMethod(WeSDKMethod.onDefaultMsgBeforeSendHandler, data, object :
//                        MethodChannel.Result {
//                        override fun success(result: Any?) {
//                            val param = result as JSONObject
//                            var seq: Long = 0
//                            try {
//                                seq = param.getJSONObject("message").getLong("seq")
//                            } catch (ignored: JSONException) {
//
//                            }
//                            val newMessage =
//                                Gson().fromJson(param.getString("message"), WeMessage::class.java)
//                            newMessage.id = seq
//                            callback?.callback(newMessage)
//                        }
//
//                        override fun error(
//                            errorCode: String?,
//                            errorMessage: String?,
//                            errorDetails: Any?
//                        ) {
//                            Log.e(TAG, "error: $errorCode  $errorMessage")
//                            callback?.callback(message)
//                        }
//
//                        override fun notImplemented() {
//                            callback?.callback(message)
//                        }
//
//                    })
//                }
//            }
//
//        })
//        IMMessageManager.setDefaultMsgBeforeReceiveHandler(object : MessageBeforeHandler() {
//            override fun processEvent0(
//                conversation: IMConversation?,
//                message: WeMessage?,
//                callback: Callback<WeMessage>?
//            ) {
//                val data: MutableMap<String, Any> = HashMap()
//                data["conversation"] = conversation?.info?.toMap() ?: return
//                data["message"] = message?.toMap() ?: return
//                post {
//                    channel.invokeMethod(WeSDKMethod.onDefaultMsgBeforeReceiveHandler, data, object :
//                        MethodChannel.Result {
//                        override fun success(result: Any?) {
//                            val param = result as JSONObject
//                            var seq: Long = 0
//                            try {
//                                seq = param.getJSONObject("message").getLong("seq")
//                            } catch (ignored: JSONException) {
//
//                            }
//                            val newMessage =
//                                Gson().fromJson(param.getString("message"), WeMessage::class.java)
//                            newMessage.id = seq
//                            callback?.callback(newMessage)
//                        }
//
//                        override fun error(
//                            errorCode: String?,
//                            errorMessage: String?,
//                            errorDetails: Any?
//                        ) {
//                            Log.e(TAG, "error: $errorCode  $errorMessage")
//                            callback?.callback(message)
//                        }
//
//                        override fun notImplemented() {
//                            callback?.callback(message)
//                        }
//
//                    })
//                }
//            }
//
//        })
    }

    private val TAG = "WeChatManagerWrapper"
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val param = call.arguments as JSONObject
        try {
            when (call.method) {
                //发送消息
                WeSDKMethod.sendMessage -> sendMessage(param, WeSDKMethod.sendMessage, result)
                //插入消息到数据库
                WeSDKMethod.insertMessageDB -> insertMessageDB(
                    param,
                    WeSDKMethod.insertMessageDB,
                    result
                )
                //更新消息的文件的本地路径
                WeSDKMethod.updateMessageFileLocPath -> updateMessageFileLocPath(
                    param,
                    WeSDKMethod.updateMessageFileLocPath,
                    result
                )
                //更新文件本地路径
                WeSDKMethod.updateMessageAttrs -> updateMessageAttrs(
                    param,
                    WeSDKMethod.updateMessageAttrs,
                    result
                )
                //同步离线消息
                WeSDKMethod.syncOfflineMessages -> syncOfflineMessages(
                    param,
                    WeSDKMethod.syncOfflineMessages,
                    result
                )
                //查询历史消息
                WeSDKMethod.findHistMsg -> findHistMsg(
                    param,
                    WeSDKMethod.findHistMsg,
                    result
                )
                //查询本地所有聊天记录
                WeSDKMethod.findMessageFromHistory -> findMessageFromHistory(
                    param,
                    WeSDKMethod.findMessageFromHistory,
                    result
                )
                //通过时间查询聊天记录
                WeSDKMethod.findMessageFromHistoryByTime -> findMessageFromHistoryByTime(
                    param,
                    WeSDKMethod.findMessageFromHistoryByTime,
                    result
                )
            }
        } catch (ignored: JSONException) {

        }
    }

    //通过时间查询聊天记录
    private fun findMessageFromHistoryByTime(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val endTime = param.getLong("endTime")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.findMessageFromHistoryByTime(
            endTime,
            object : ICallback<List<WeMessage>>() {
                override fun internalDone0(
                    t: List<WeMessage>?,
                    weException: WeException?
                ) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        val res = t?.map { it.toMap() }
                        onSuccess(result, channelName, res)
                    }
                }
            })
    }

    //查询本地所有聊天记录
    private fun findMessageFromHistory(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.findMessageFromHistory(object : ICallback<List<WeMessage>>() {
            override fun internalDone0(t: List<WeMessage>?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    val res = t?.map { it.toMap() }
                    onSuccess(result, channelName, res)
                }
            }
        })
    }

    //查询历史消息
    private fun findHistMsg(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val conversationId = param.getLong("conversationId")
        val lastMsg = Gson().fromJson(param.getString("lastMsg"), WeMessage::class.java)
        val pageSize = param.getInt("pageSize")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.findHistMsgV2(lastMsg, pageSize,
            object : ICallback<PageResponse<WeMessage>>() {
                override fun internalDone0(
                    t: PageResponse<WeMessage>?,
                    weException: WeException?
                ) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        val records = t?.records?.map { it.toMap() }
                        onSuccess(result, channelName, records)
                    }
                }
            })
    }

    //同步离线消息
    private fun syncOfflineMessages(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.syncOfflineMessages(object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
//                if (weException != null) {
//                    onError(result, weException)
//                } else {
                onSuccess(result, channelName, true)
//                }
            }
        })
    }

    //更新消息的文件的本地路径
    private fun updateMessageFileLocPath(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val msgId = param.getLong("msgId")
        val localPath = param.getString("localPath")
        IMClient.getInstance()
            .updateMessageFileLocPath(msgId, localPath, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //更新文件本地路径
    private fun updateMessageAttrs(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val msgId = param.getLong("msgId")
        val attrsJson = param.getString("attrs")
        val attrs = Gson().fromJson<Map<String, String>>(
            attrsJson,
            object : TypeToken<Map<String, String>>() {}.type
        )
        IMClient.getInstance()
            .updateMessageAttrs(msgId, attrs, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    private fun sendMessage(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        Log.e("sendMessage", param.getString("message"))
        var seq: Long = 0
        var file: WeFileMsgInfo? = null
        try {
            val jsonObject = param.getJSONObject("message")
            seq = jsonObject.getLong("seq")
            val fileJson = jsonObject.getString("file")
            file = Gson().fromJson(fileJson, WeFileMsgInfo::class.java)
        } catch (ignored: JSONException) {

        }
        val message = Gson().fromJson(param.getString("message"), WeMessage::class.java)
        message.id = seq
        if(file!=null){
            message.files = listOf(file)
        }
        val conversation = getConversation(message.conversationId, result) ?: return
        val msgReqId = message.reqId
        conversation.sendMessage(message, object : IMMesssageCallback() {
            override fun done(message: WeMessage?, e: WeException?) {
                if (e != null) {
                    val data: MutableMap<String, Any> = HashMap()
                    data["reqId"] = msgReqId
                    data["errCode"] = e.code
                    channel.invokeMethod(WeSDKMethod.onMessageSendFail, data)
                }
            }
        })
        onSuccess(result, channelName, true)
    }

    private fun insertMessageDB(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        Log.e("insertMessageDB", param.getString("message"))
        var seq: Long = 0
        var file: WeFileMsgInfo? = null
        try {
            val jsonObject = param.getJSONObject("message")
            seq = jsonObject.getLong("seq")
            val fileJson = jsonObject.getString("file")
            file = Gson().fromJson(fileJson, WeFileMsgInfo::class.java)
        } catch (ignored: JSONException) {

        }
        val message = Gson().fromJson(param.getString("message"), WeMessage::class.java)
        message.id = seq
        if(file!=null){
            message.files = listOf(file)
        }
        val conversation = getConversation(message.conversationId, result) ?: return
        conversation.insertOrUpdateMessageDB(message)
        onSuccess(result, channelName, true)
    }

    private fun getConversation(
        conversationId: Long,
        result: MethodChannel.Result
    ): IMConversation? {
        if (conversationId == 0L) {
            onError(result, WeException(WeException.OTHER_CAUSE, "conversationId cannot be empty"))
            return null
        }
        val conversation = IMClient.getInstance().getConversation(conversationId)
        if (conversation == null) {
            onError(
                result,
                WeException(WeException.OTHER_CAUSE, "This conversation cannot be found")
            )
            return null
        }
        return conversation
    }
}