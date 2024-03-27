package cn.wecloud.im.wecloudchatkit_flutter

import android.app.Application
import android.text.TextUtils
import android.util.Log
import cn.wecloud.im.WeCloud
import cn.wecloud.im.callback.IMClientCallback
import cn.wecloud.im.core.db.entity.WeFileMsgInfo
import cn.wecloud.im.core.db.entity.WeMessage
import cn.wecloud.im.core.http.HttpReqModel
import cn.wecloud.im.core.http.model.*
import cn.wecloud.im.core.im.IMClient
import cn.wecloud.im.core.im.IMConversation
import cn.wecloud.im.core.im.IMMessageManager
import cn.wecloud.im.core.im.TransparentEventHandler
import cn.wecloud.im.core.im.callback.ICallback
import cn.wecloud.im.core.im.callback.IMConversationCreatedCallback
import cn.wecloud.im.core.im.messages.TransparentEvent
import cn.wecloud.im.core.im.messages.WeMessageType
import cn.wecloud.im.core.session.SessionStatus
import cn.wecloud.im.exception.IMException
import cn.wecloud.im.exception.WeException
import cn.wecloud.im.wecloudchatkit_flutter.utils.EmptyLogable
import cn.wecloud.im.wecloudchatkit_flutter.utils.toBeanList
import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import com.zhangke.websocket.WebSocketHandler
import com.zhangke.websocket.util.Logable
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import org.json.JSONException
import org.json.JSONObject
import java.util.ArrayList
import java.util.HashMap

class WeClientWrapper(
    flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
) : PluginWrapper(flutterPluginBinding, CHANNEL_NAME), MethodCallHandler {

    companion object {
        private const val TAG = "WeClientWrapper"

        const val CHANNEL_NAME = "chat_client"

        private var clientWrapper: WeClientWrapper? = null

        fun getInstance(): WeClientWrapper? {
            return clientWrapper
        }
    }

    init {
        clientWrapper = this
        registerListener()
    }

    private fun registerListener() {
        IMMessageManager.registerTransparentHandler(object : TransparentEventHandler() {
            override fun processTransparentEvent(data: TransparentEvent?) {
                super.processTransparentEvent(data)
                post {
                    channel.invokeMethod(
                        WeSDKMethod.onTransparentMessageEvent, data?.toMap()
                    )
                }
            }
        })
        IMMessageManager.setOnSDKConnListener {
            Log.e(TAG,"setOnSDKConn:"+it)
            post {
                channel.invokeMethod(WeSDKMethod.onSDKConnEvent, it.toString())
            }
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val param = call.arguments as? JSONObject ?: JSONObject()
        try {
            Log.e(TAG, "onMethodCall: ${call.method}")
            when (call.method) {
                //初始化http和ws的url
                WeSDKMethod.initialize -> initialize(param, WeSDKMethod.initialize, result)
                //登录且开启模块
                WeSDKMethod.loginAndOpen -> loginAndOpen(param, WeSDKMethod.loginAndOpen, result)
                //模块是否已登录
                WeSDKMethod.isLogin -> isLogin(WeSDKMethod.isLogin, result)
                //开启模块
                WeSDKMethod.open -> open(WeSDKMethod.open, result)
                //开启模块
                WeSDKMethod.openModel -> openModel(param, WeSDKMethod.openModel, result)
                //关闭模块
                WeSDKMethod.close -> close(WeSDKMethod.close, result)
                //添加或修改推送设备信息
                WeSDKMethod.updateDeviceInfo -> updateDeviceInfo(
                    param, WeSDKMethod.updateDeviceInfo, result
                )
                //创建会话
                WeSDKMethod.createConversation -> createConversation(
                    param, WeSDKMethod.createConversation, result
                )
                //加入聊天室
                WeSDKMethod.joinChatRoom -> joinChatRoom(
                    param, WeSDKMethod.joinChatRoom, result
                )
                //退出聊天室
                WeSDKMethod.exitChatRoom -> exitChatRoom(
                    param, WeSDKMethod.exitChatRoom, result
                )
                //查询聊天室成员
                WeSDKMethod.findChatRoomMembers -> findChatRoomMembers(
                    param, WeSDKMethod.findChatRoomMembers, result
                )
                //查询会话
                WeSDKMethod.findConversationById -> findConversationById(
                    param, WeSDKMethod.findConversationById, result
                )

                //解散群聊
                WeSDKMethod.disbandConversation -> disbandConversation(
                    param, WeSDKMethod.disbandConversation, result
                )
                //询加入的会话
                WeSDKMethod.searchDisplayConversationList -> searchDisplayConversationList(
                    WeSDKMethod.searchDisplayConversationList, result
                )
                //查询会话中指定类型的消息
                WeSDKMethod.findConvMsgByType -> findConvMsgByType(
                    param, WeSDKMethod.findConvMsgByType, result
                )
                //查询本地所有会话，包含隐藏的
                WeSDKMethod.searchGroupConversations -> searchGroupConversations(
                    WeSDKMethod.searchGroupConversations, result
                )
                //显示或隐藏会话
                WeSDKMethod.displayConversation -> displayConversation(
                    param, WeSDKMethod.displayConversation, result
                )
                //删除会话(逻辑删除，隐藏会话并删除会话中的所有消息)
                WeSDKMethod.deleteConversations -> deleteConversations(
                    param, WeSDKMethod.deleteConversations, result
                )
                //删除会话（删除数据库中关于此会话的所有数据）
                WeSDKMethod.deleteConversationFromDB -> deleteConversationFromDB(
                    param, WeSDKMethod.deleteConversationFromDB, result
                )
                //退出会话
                WeSDKMethod.leaveConv -> leaveConv(
                    param, WeSDKMethod.leaveConv, result
                )
                //设置群管理员
                WeSDKMethod.setupConvAdmins -> setupConvAdmins(
                    param, WeSDKMethod.setupConvAdmins, result
                )
                //群主转让
                WeSDKMethod.convTransferOwner -> convTransferOwner(
                    param, WeSDKMethod.convTransferOwner, result
                )
                //群成员禁言
                WeSDKMethod.convMutedGroupMenber -> convMutedGroupMenber(
                    param, WeSDKMethod.convMutedGroupMenber, result
                )
                //撤回消息
                WeSDKMethod.withdrawMsg -> withdrawMsg(
                    param, WeSDKMethod.withdrawMsg, result
                )
                //删除消息(连同服务器一起删除)
                WeSDKMethod.deleteMsgAndNetwork -> deleteMsgAndNetwork(
                    param, WeSDKMethod.deleteMsgAndNetwork, result
                )
                //删除会话的所有消息(只删除本地数据库)
                WeSDKMethod.deleteAllMsgByConvId -> deleteAllMsgByConvId(
                    param, WeSDKMethod.deleteAllMsgByConvId, result
                )
                //删除指定的消息
                WeSDKMethod.deleteAllMsg -> deleteAllMsg(
                    param, WeSDKMethod.deleteAllMsg, result
                )
                //消息已读回执
                WeSDKMethod.msgReadUpdate -> msgReadUpdate(
                    param, WeSDKMethod.msgReadUpdate, result
                )
                //把会话中msgIdEnd之前所有消息更新为已读
                WeSDKMethod.msgReadAllConvUpdate -> msgReadAllConvUpdate(
                    param, WeSDKMethod.msgReadAllConvUpdate, result
                )
                //查询指定消息
                WeSDKMethod.findMessage -> findMessage(
                    param, WeSDKMethod.findMessage, result
                )
                //拉入黑名单
                WeSDKMethod.addBlacklist -> addBlacklist(
                    param, WeSDKMethod.addBlacklist, result
                )
                //移除黑名单
                WeSDKMethod.delBlacklist -> delBlacklist(
                    param, WeSDKMethod.delBlacklist, result
                )
                //黑名单分页列表
                WeSDKMethod.findBlacklist -> findBlacklist(
                    param, WeSDKMethod.findBlacklist, result
                )
                //查询群用户信息
                WeSDKMethod.findGroupInfoList -> findGroupInfoList(
                    param, WeSDKMethod.findGroupInfoList, result
                )
                //获取当前连接状态
                WeSDKMethod.getConnectingStatus -> getConnectingStatus(
                    param, WeSDKMethod.getConnectingStatus, result
                )
            }
        } catch (ignored: JSONException) {

        }
    }

    //获取当前连接状态
    private fun getConnectingStatus(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val status = IMClient.getInstance().connectingStatus
        Log.e(TAG, "getConnectingStatus: "+status )
        onSuccess(result, channelName, status.toString())
    }

    //查询群用户信息
    private fun findGroupInfoList(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val clientInfos = param.getString("clientInfos").toBeanList<String>()
        IMClient.getInstance().getClientInfoList(conversationId, clientInfos,
            object : ICallback<List<ClientInfo>>() {
                override fun internalDone0(
                    t: List<ClientInfo>?,
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

    //黑名单分页列表
    private fun findBlacklist(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val pageIndex = param.getInt("pageIndex")
        val pageSize = param.getInt("pageSize")
        IMClient.getInstance()
            .findBlacklist(pageIndex, pageSize, object : ICallback<PageResponse<Blacklist>>() {
                override fun internalDone0(t: PageResponse<Blacklist>?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        val friendInfos = t?.records?.map { it.clientIdBePrevent }
                        onSuccess(result, channelName, friendInfos)
                    }
                }
            })
    }

    //移除黑名单
    private fun delBlacklist(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val userClientId = param.getString("userClientId")
        IMClient.getInstance().delBlacklist(userClientId, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //拉入黑名单
    private fun addBlacklist(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val userClientId = param.getString("userClientId")
        IMClient.getInstance().addBlacklist(userClientId, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //查询指定消息
    private fun findMessage(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val messageId = param.getLong("messageId")
        IMClient.getInstance().findMessage(messageId, object : ICallback<WeMessage>() {
            override fun internalDone0(t: WeMessage?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, t?.toMap())
                }
            }
        })
    }

    //把会话中msgIdEnd之前所有消息更新为已读
    private fun msgReadAllConvUpdate(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val lastMsgId = param.getLong("lastMsgId")
        val model = MsgReadAllConvUpdateModel(conversationId, true)
        IMClient.getInstance().msgReadAllConvUpdateV2(listOf(model),
            object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //消息已读回执
    private fun msgReadUpdate(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val lastReadMsgId = param.getLong("lastReadMsgId")
        val isUnread = param.getBoolean("isUnread")
        val needCount = param.getBoolean("needCount")
        val isMessageRead = param.getBoolean("isMessageRead")
        IMClient.getInstance()
            .setupMessageReadMark(
                conversationId,
                lastReadMsgId,
                isUnread,
                needCount,
                isMessageRead,
                object : ICallback<Int>() {
                    override fun internalDone0(t: Int?, weException: WeException?) {
                        if (weException != null) {
                            onError(result, weException)
                        } else {
                            onSuccess(result, channelName, true)
                        }
                    }
                })

    }

    //删除指定的消息
    private fun deleteAllMsg(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val messages = param.getJSONArray("messages")
        val messageList = ArrayList<WeMessage>()
        for (i in 0 until messages.length()) {
            var seq: Long = 0
            var file: WeFileMsgInfo? = null
            try {
                val jsonObject = messages.getJSONObject(i)
                seq = jsonObject.getLong("seq")
                val fileJson = jsonObject.getString("file")
                file = Gson().fromJson(fileJson, WeFileMsgInfo::class.java)
            } catch (ignored: JSONException) {

            }
            val message = Gson().fromJson(messages.getString(i), WeMessage::class.java)
            message.id = seq
            if (file != null) {
                message.files = listOf(file)
            }
            messageList.add(message)
        }
        IMClient.getInstance().deleteAllMsg(messageList, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //删除会话的所有消息(只删除本地数据库)
    private fun deleteAllMsgByConvId(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        IMClient.getInstance().cleanConversationMsg(conversationId, object : ICallback<Boolean>() {
            override fun internalDone0(t: Boolean?, weException: WeException?) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //删除消息(连同服务器一起删除)
    private fun deleteMsgAndNetwork(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val messages = param.getJSONArray("messages")
        val messageList = ArrayList<WeMessage>()
        for (i in 0 until messages.length()) {
            var seq: Long = 0
            var file: WeFileMsgInfo? = null
            try {
                val jsonObject = messages.getJSONObject(i)
                seq = jsonObject.getLong("seq")
                val fileJson = jsonObject.getString("file")
                file = Gson().fromJson(fileJson, WeFileMsgInfo::class.java)
            } catch (ignored: JSONException) {

            }
            val message = Gson().fromJson(messages.getString(i), WeMessage::class.java)
            message.id = seq
            if (file != null) {
                message.files = listOf(file)
            }
            messageList.add(message)
        }
        IMClient.getInstance().deleteMsgAndNetwork(messageList, object : IMClientCallback() {
            override fun done(client: IMClient?, e: IMException?) {
                if (e != null) {
                    onError(result, e)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //撤回消息
    private fun withdrawMsg(param: JSONObject, channelName: String, result: MethodChannel.Result) {
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
        if (file != null) {
            message.files = listOf(file)
        }
        IMClient.getInstance().withdrawMsg(message, object : IMClientCallback() {
            override fun done(client: IMClient?, e: IMException?) {
                if (e != null) {
                    onError(result, e)
                } else {
                    onSuccess(result, channelName, true)
                }
            }
        })
    }

    //群成员禁言
    private fun convMutedGroupMenber(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val clientIds = param.getString("clientIds").toBeanList<String>()
        val isMuted = param.getBoolean("isMuted")
        IMClient.getInstance()
            .convMutedGroupMenber(conversationId, clientIds, isMuted,
                object : ICallback<Boolean>() {
                    override fun internalDone0(t: Boolean?, weException: WeException?) {
                        if (weException != null) {
                            onError(result, weException)
                        } else {
                            onSuccess(result, channelName, true)
                        }
                    }
                })
    }

    //群主转让
    private fun convTransferOwner(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val clientId = param.getString("clientId")
        IMClient.getInstance()
            .convTransferOwner(conversationId, clientId, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //设置群管理员
    private fun setupConvAdmins(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val clientIds = param.getString("clientIds").toBeanList<String>()
        val operateType = param.getInt("operateType")
        IMClient.getInstance().setupConvAdmins(
            conversationId, clientIds, operateType,
            object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //退出会话
    private fun leaveConv(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val conversationId = param.getLong("conversationId")
        IMClient.getInstance()
            ?.leaveConv(conversationId, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //删除会话(逻辑删除，隐藏会话并删除会话中的所有消息)
    private fun deleteConversations(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationIds: List<Long> = Gson().fromJson(
            param.getString("conversationIds"),
            object : TypeToken<List<Long>>() {}.type
        )
        IMClient.getInstance()
            .deleteConversations(conversationIds, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //删除会话（删除数据库中关于此会话的所有数据）
    private fun deleteConversationFromDB(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        IMClient.getInstance()
            .deleteConversationFromDB(conversationId, object : ICallback<IMConversation>() {
                override fun internalDone0(t: IMConversation?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //显示或隐藏会话
    private fun displayConversation(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationIds: List<Long> = Gson().fromJson(
            param.getString("conversationIds"),
            object : TypeToken<List<Long>>() {}.type
        )
        val displayStatus = param.getBoolean("displayStatus")
        IMClient.getInstance()
            .displayConversation(conversationIds, displayStatus, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    private fun initialize(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val httpUrl = param.getString("httpUrl")
        val wsUrl = param.getString("wsUrl")
        Log.e("initialize", "httpUrl: $httpUrl  wsUrl:$wsUrl")
        bindingManagers()
        WebSocketHandler.setLogable(EmptyLogable())
        val app = context as? Application
        if (app == null) {
            Log.e("initialize", "err context as? Application")
        }
        WeCloud.initialize(app, httpUrl, wsUrl)
//        WeCloud.setHttpReqModel(HttpReqModel.http)
//        WeCloud.setHttpReqModel(HttpReqModel.ws)
        onSuccess(result, channelName, true)
    }

    private fun bindingManagers() {
        WeFriendManagerWrapper(binging)
        WeChatManagerWrapper(binging)
        WeConversationManagerWrapper(binging)
        WeSingRtcWrapper(binging)
    }

    private fun searchGroupConversations(
        channelName: String,
        result: MethodChannel.Result
    ) {
        IMClient.getInstance().searchGroupConversations(object : ICallback<List<IMConversation>>() {
            override fun internalDone0(
                conversations: List<IMConversation>?,
                weException: WeException?
            ) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    val list = conversations?.map { it.info.toMap() }
                    onSuccess(result, channelName, list)
                }
            }
        })
    }

    //查询会话中指定类型的消息
    private fun findConvMsgByType(
        param: JSONObject, channelName: String, result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val msgTypes = param.getJSONArray("types")
        val types: MutableList<WeMessageType> = ArrayList()
        for (i in 0 until msgTypes.length()) {
            val type = msgTypes[i] as Int
            types.add(WeMessageType.getMsgType(type))
        }
        IMClient.getInstance().findConvMsgByType(
            conversationId, types,
            object : ICallback<List<WeMessage>>() {
                override fun internalDone0(list: List<WeMessage>?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        val res = list?.map { it.toMap() }
                        onSuccess(result, channelName, res)
                    }
                }
            })
    }

    //询加入的会话
    private fun searchDisplayConversationList(
        channelName: String,
        result: MethodChannel.Result
    ) {
        IMClient.getInstance().searchDisplayConversationListV2(object :
            ICallback<List<IMConversation>>() {
            override fun internalDone0(
                conversations: List<IMConversation>?,
                weException: WeException?
            ) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    val list = conversations?.map { it.info.toMap() }
                    onSuccess(result, channelName, list)
                }
            }
        })
    }

    //解散群聊
    private fun disbandConversation(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        IMClient.getInstance()
            ?.disbandConversation(conversationId, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //创建会话
    private fun createConversation(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val clientIds = if (param.isNull("clientIds")) null else param.getString("clientIds")
            .toBeanList<String>()
        val name = if (param.isNull("name")) null else param.getString("name")
        val attributes = if (param.isNull("attributes")) null else param.getString("attributes")
        val platform = if (param.isNull("platform")) null else param.getInt("platform")
        val chatType = param.getInt("chatType")
        val isEncrypt = param.getBoolean("isEncrypt")
        IMClient.getInstance()
            .createConversation(clientIds, name, attributes, chatType, platform, isEncrypt, object :
                IMConversationCreatedCallback() {
                override fun done(conversation: IMConversation?, e: IMException?) {
                    if (e != null) {
                        onError(result, e)
                    } else {
                        onSuccess(result, channelName, conversation?.info?.toMap())
                    }
                }
            })
    }

    //加入聊天室
    private fun joinChatRoom(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val chatRoomId = param.getLong("chatRoomId")
        val clientId = param.getString("clientId")
        val platform = param.getInt("platform")
        IMClient.getInstance()
            ?.joinChatRoom(chatRoomId, clientId, platform, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //退出聊天室
    private fun exitChatRoom(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val chatRoomId = param.getLong("chatRoomId")
        val clientId = param.getString("clientId")
        val platform = param.getInt("platform")
        IMClient.getInstance()
            ?.exitChatRoom(chatRoomId, clientId, platform, object : ICallback<Boolean>() {
                override fun internalDone0(t: Boolean?, weException: WeException?) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
    }

    //查询聊天室成员
    private fun findChatRoomMembers(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val chatRoomId = param.getLong("chatRoomId")
        IMClient.getInstance().findChatRoomMembers(chatRoomId, object :
            ICallback<List<ChatRoomMember>>() {
            override fun internalDone0(
                chatRoomMembers: List<ChatRoomMember>?,
                weException: WeException?
            ) {
                if (weException != null) {
                    onError(result, weException)
                } else {
                    val list = chatRoomMembers?.map { it.toMap() }
                    onSuccess(result, channelName, list)
                }
            }
        })
    }

    //查询会话
    private fun findConversationById(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val conversationId = param.getLong("conversationId")
        val chatType = if (param.isNull("chatType")) null else param.getInt("chatType")
        IMClient.getInstance()
            .findConversationById(conversationId, chatType, object : ICallback<IMConversation>() {
                override fun internalDone0(
                    conversation: IMConversation?,
                    weException: WeException?
                ) {
                    if (weException != null) {
                        onError(result, weException)
                    } else {
                        onSuccess(result, channelName, conversation?.info?.toMap())
                    }
                }
            })
    }

    //登录且开启模块
    private fun loginAndOpen(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val clientId = param.getString("clientId")
        val appKey = param.getString("appKey")
        val timestamp = param.getString("timestamp")
        val sign = param.getString("sign")
        val platform = param.getInt("platform")
        IMClient.getInstance().login(clientId, appKey, timestamp, sign, platform,
            object : IMClientCallback() {
                override fun done(client: IMClient?, e: IMException?) {
                    if (e != null) {
                        onError(result, e)
                    } else {
                        val data: MutableMap<String, Any?> = HashMap()
                        data["token"] = WeCloud.getToken()
                        data["clientId"] = WeCloud.getClientId()
                        onSuccess(result, channelName, data)
                    }
                }
            })
    }

    //开启模块
    private fun open(channelName: String, result: MethodChannel.Result) {
        try {
            IMClient.getInstance().open(object : IMClientCallback() {
                override fun done(client: IMClient?, e: IMException?) {
                    if (e != null) {
                        onError(result, e)
                    } else {
                        val data: MutableMap<String, Any?> = HashMap()
                        data["token"] = WeCloud.getToken()
                        data["clientId"] = WeCloud.getClientId()
                        onSuccess(result, channelName, data)
                    }
                }
            })
        } catch (e: IllegalArgumentException) {
            onError(result, WeException(-1, e.message))
        }
    }

    //开启模块
    private fun openModel(param: JSONObject, channelName: String, result: MethodChannel.Result) {
        val clientId = param.getString("clientId")
        val appKey = param.getString("appKey")
        val token = param.getString("token")
        try {
            IMClient.getInstance().open(clientId, appKey, token, object : IMClientCallback() {
                override fun done(client: IMClient?, e: IMException?) {
                    if (e != null) {
                        onError(result, e)
                    } else {
                        onSuccess(result, channelName, true)
                    }
                }
            })
        } catch (e: IllegalArgumentException) {
            onError(result, WeException(-1, e.message))
        }
    }

    //模块是否已登录
    private fun isLogin(channelName: String, result: MethodChannel.Result) {
        val appKey = WeCloud.getAppKey()
        val clientId = WeCloud.getClientId()
        val token = WeCloud.getToken()
        Log.e(TAG, "isLogin: appKey:$appKey\nclientId:$clientId\ntoken:$token")
        onSuccess(result, channelName, IMClient.getInstance().isLogin)
    }

    //关闭模块
    private fun close(channelName: String, result: MethodChannel.Result) {
        IMClient.getInstance().close(object : IMClientCallback() {
            override fun done(client: IMClient?, e: IMException?) {
                onSuccess(result, channelName, true)
            }
        })
    }

    //添加或修改推送设备信息
    private fun updateDeviceInfo(
        param: JSONObject,
        channelName: String,
        result: MethodChannel.Result
    ) {
        val pushChannel = param.getString("pushChannel") // 设备接入推送的渠道
        val valid = param.getInt("valid") // 设备不想收到推送提醒, 1想, 0不想
        val deviceToken = param.getString("deviceToken") //设备推送token
        IMClient.getInstance()
            .updateDeviceInfo(pushChannel, valid, deviceToken, object : ICallback<Boolean>() {
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