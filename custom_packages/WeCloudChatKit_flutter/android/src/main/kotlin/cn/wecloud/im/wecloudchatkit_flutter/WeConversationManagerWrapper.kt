package cn.wecloud.im.wecloudchatkit_flutter

import android.util.Log
import cn.wecloud.im.core.db.OnDBCallback
import cn.wecloud.im.core.db.entity.ConversationInfo
import cn.wecloud.im.core.db.entity.MemberInfo
import cn.wecloud.im.core.im.*
import cn.wecloud.im.core.im.callback.ICallback
import cn.wecloud.im.core.im.messages.ConvEvent
import cn.wecloud.im.exception.WeException
import cn.wecloud.im.wecloudchatkit_flutter.utils.toBeanList
import com.google.gson.Gson
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import org.json.JSONException
import org.json.JSONObject
import java.util.HashMap

class WeConversationManagerWrapper(
    flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PluginWrapper(flutterPluginBinding, CHANNEL_NAME), MethodChannel.MethodCallHandler {

    companion object {
        private const val TAG = "WeConversationManagerWr"
        const val CHANNEL_NAME = "conversation_manager"
    }

    init {
        registerListener()
    }

    private fun registerListener() {
        IMMessageManager.registerConversationChangeEvent(object : ConversationChangeEvent() {
            override fun onConversationChangeEvent(
                conversation: IMConversation?,
                eventData: ConvEvent?,
                convEventType: ConvEventType?
            ) {
                if (convEventType == ConvEventType.CONV_EVENT_LAST_MSG_CHANGE) {
                    //最后消息更新，由flutter自己处理
                    if (conversation?.isHide == true) {
                        conversation.isHide = false
                        post {
                            channel.invokeMethod(
                                WeSDKMethod.onAddConversation, conversation.info?.toMap()
                            )
                        }
                    }
                    if (conversation?.lastMsg != null && conversation.lastMsg.isWithdraw) {
                        val data: MutableMap<String, Any> = HashMap()
                        data["event"] = "withdrawLastMsg"
                        data["conversation"] = conversation.info?.toMap() ?: return
                        post {
                            channel.invokeMethod(
                                WeSDKMethod.onUpdateConversation, data
                            )
                        }
                    }
                    return
                } else if (convEventType == ConvEventType.CONV_EVENT_REFRESH) {
                    post {
                        val data: MutableMap<String, Any> = HashMap()
                        data["event"] = "refreshConversation"
                        data["conversation"] = conversation?.info?.toMap() ?: return@post
                        channel.invokeMethod(WeSDKMethod.onUpdateConversation, data)
                    }
                } else {
                    post {
                        channel.invokeMethod(
                            WeSDKMethod.onConversationEvent,
                            eventData?.toMap()
                        )
                    }
                }
            }

            override fun onAddConversation(conversation: IMConversation?) {
                post {
                    channel.invokeMethod(
                        WeSDKMethod.onAddConversation,
                        conversation?.info?.toMap()
                    )
                }
            }

            override fun onRemoveConversation(conversation: IMConversation?) {
                post {
                    channel.invokeMethod(
                        WeSDKMethod.onRemoveConversation,
                        conversation?.conversationId
                    )
                }
            }
        })

        IMMessageManager.registerTotalNotReadCountChangeListener(object :
            TotalNotReadCountChangeListener() {
            override fun onTotalNotReadCountChange(totalNotReadCount: Int) {
                post {
                    channel.invokeMethod(
                        WeSDKMethod.onTotalNotReadCountChangeListener,
                        totalNotReadCount
                    )
                }
            }
        })
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val param = call.arguments as JSONObject
        try {
            when (call.method) {
                //添加会话成员
                WeSDKMethod.addMember -> addMember(param, WeSDKMethod.addMember, result)
                //更新本地会话名字
                WeSDKMethod.updateNameFromLocal -> updateNameFromLocal(
                    param,
                    WeSDKMethod.updateNameFromLocal,
                    result
                )
                //更新本地会话头像
                WeSDKMethod.updateHeadPortraitFromLocal -> updateHeadPortraitFromLocal(
                    param,
                    WeSDKMethod.updateHeadPortraitFromLocal,
                    result
                )
                //删除会话成员
                WeSDKMethod.delMember -> delMember(param, WeSDKMethod.delMember, result)
                //查询本会话的成员
                WeSDKMethod.searchConvMembers -> searchConvMembers(
                    param,
                    WeSDKMethod.searchConvMembers,
                    result
                )
                //添加或修改会话的拓展字段
                WeSDKMethod.updateConversationAttr -> updateConversationAttr(
                    param,
                    WeSDKMethod.updateConversationAttr,
                    result
                )
                //修改群名字 (群主可用)
                WeSDKMethod.updateConversationName -> updateConversationName(
                    param,
                    WeSDKMethod.updateConversationName,
                    result
                )
                //修改群昵称
                WeSDKMethod.updateConvMemberRemark -> updateConvMemberRemark(
                    param,
                    WeSDKMethod.updateConvMemberRemark,
                    result
                )
                //设置群禁言
                WeSDKMethod.setGroupMuted -> setGroupMuted(param, WeSDKMethod.setGroupMuted, result)
                //草稿
                WeSDKMethod.saveDraft -> saveDraft(param, WeSDKMethod.saveDraft, result)
                //群解散状态
                WeSDKMethod.setDisband -> setDisband(param, WeSDKMethod.setDisband, result)
                //同步群会话成员
                WeSDKMethod.syncGroupMembers -> syncGroupMembers(param, WeSDKMethod.syncGroupMembers, result)
                //更新本地会话数据
                WeSDKMethod.onUpdateConversationFromDB -> onUpdateConversationFromDB(
                    param,
                    WeSDKMethod.onUpdateConversationFromDB,
                    result
                )
            }
        } catch (ignored: JSONException) {

        }
    }

    //群解散状态
    private fun setDisband(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val conversationId = param.getLong("conversationId")
        val disband = param.getBoolean("disband")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.isDisband = disband
        onSuccess(result, channelName, true)
    }


    private fun syncGroupMembers(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val conversationId = param.getLong("conversationId")
        IMClient.getInstance().syncGroupMembers(conversationId)
        onSuccess(result, channelName, true)
    }

    //更新本地会话数据
    private fun onUpdateConversationFromDB(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val json = param.getString("conversation")
        val convInfo =
            Gson().fromJson(json, ConversationInfo::class.java)
        val jsonObj = param.getJSONObject("conversation")
        convInfo.isTop = jsonObj.getBoolean("isTop")
        convInfo.isDoNotDisturb = jsonObj.getBoolean("isDoNotDisturb")
        Log.e(TAG, "onUpdateConversationFromDB1111: ${convInfo.toMap()}")
        IMClient.getInstance().updateConversationCache(convInfo, true)
        onSuccess(result, channelName, true)
    }

    //草稿
    private fun saveDraft(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val conversationId = param.getLong("conversationId")
        val draftJson = param.getString("draftJson")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.saveDraft(draftJson)
        onSuccess(result, channelName, true)
    }

    //设置群禁言
    private fun setGroupMuted(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val isMuted = param.getBoolean("isMuted")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.setGroupMuted(isMuted, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }

        })
    }

    //修改群昵称
    private fun updateConvMemberRemark(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val remarkName = param.getString("remarkName")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.updateConvMemberRemark(remarkName, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //添加或修改会话的拓展字段
    private fun updateConversationAttr(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val attributes = param.getString("attributes")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.updateConversationAttr(attributes, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //修改群名字 (群主可用)
    private fun updateConversationName(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val groupName = param.getString("groupName")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.updateConversationName(groupName, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //查询本会话的成员
    private fun searchConvMembers(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.searchConvMembers(object : ICallback<List<MemberInfo>>() {
            override fun internalDone0(t: List<MemberInfo>?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    val res = t?.map { it.toMap() }
                    onSuccess(result, channelName, res)
                }
            }
        })
    }

    //添加会话成员
    private fun addMember(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val conversationId = param.getLong("conversationId")
        val addMembers = param.getString("addMembers").toBeanList<String>()
        val conversation = getConversation(conversationId, result) ?: return
        conversation.addMember(addMembers, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //更新本地会话名字
    private fun updateNameFromLocal(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val name = param.getString("name")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.updateNameFromLocal(name, object : OnDBCallback<Boolean>() {
            override fun onSuccess(data: Boolean?) {
                super.onSuccess(data)
                onSuccess(result, channelName, true)
            }

            override fun onFailure(code: Int, message: String?) {
                super.onFailure(code, message)
                onError(result, WeException(code, message))
            }
        })
    }

    //更新本地会话头像
    private fun updateHeadPortraitFromLocal(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val headPortrait = param.getString("headPortrait")
        val conversation = getConversation(conversationId, result) ?: return
        conversation.updateHeadPortraitFromLocal(headPortrait, object : OnDBCallback<Boolean>() {
            override fun onSuccess(data: Boolean?) {
                super.onSuccess(data)
                onSuccess(result, channelName, true)
            }

            override fun onFailure(code: Int, message: String?) {
                super.onFailure(code, message)
                onError(result, WeException(code, message))
            }
        })
    }

    //删除会话成员
    private fun delMember(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val conversationId = param.getLong("conversationId")
        val delMembers = param.getString("delMembers").toBeanList<String>()
        val conversation = getConversation(conversationId, result) ?: return
        conversation.delMember(delMembers, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
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