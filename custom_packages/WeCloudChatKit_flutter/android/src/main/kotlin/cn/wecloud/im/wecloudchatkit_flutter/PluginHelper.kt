package cn.wecloud.im.wecloudchatkit_flutter

import cn.wecloud.im.core.db.entity.ConversationInfo
import cn.wecloud.im.core.db.entity.MemberInfo
import cn.wecloud.im.core.db.entity.WeFileMsgInfo
import cn.wecloud.im.core.db.entity.WeMessage
import cn.wecloud.im.core.http.model.ChatRoomMember
import cn.wecloud.im.core.http.model.ClientInfo
import cn.wecloud.im.core.im.messages.ConvEvent
import cn.wecloud.im.core.im.messages.NotifyMsg
import cn.wecloud.im.core.im.messages.RTCEvent
import cn.wecloud.im.core.im.messages.TransparentEvent
import cn.wecloud.im.exception.WeException
import java.util.HashMap

fun WeException.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["code"] = code
    data["description"] = message ?: ""
    return data
}

fun ClientInfo.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["clientRemarkName"] = clientRemarkName
    data["headPortrait"] = headPortrait
    data["nickname"] = nickname
    data["clientId"] = clientId
    data["clientAttribute"] = clientAttribute
    data["memberAttributes"] = memberAttributes
    return data
}

fun WeMessage.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["seq"] = id
    data["msgId"] = msgId
    data["createTime"] = createTime
    data["withdrawTime"] = withdrawTime
    data["withdraw"] = isWithdraw
    data["sender"] = sender
    data["type"] = type
    data["conversationId"] = conversationId
    data["event"] = isEvent
    data["system"] = isSystem
    data["at"] = at
    data["notReadCount"] = notReadCount
    data["notReceiverCount"] = notReceiverCount
    data["attrs"] = attrs
    data["text"] = text
    data["operator"] = operator
    data["name"] = name
    data["attributes"] = attributes
    data["passivityOperator"] = passivityOperator
    data["msgStatus"] = msgStatus
    data["reqId"] = reqId
    data["file"] =if(files==null || files.isEmpty()) null else files[0]?.toMap()
    data["push"] = push?.toMap()
    data["timeToBurn"] = timeToBurn
    data["burn"] = burn
    data["burnType"] = burnType
    data["expiresStart"] = expiresStart
    data["preMessageId"] = preMessageId
    return data
}

fun WeFileMsgInfo.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["fileId"] = id
    data["msgKeyId"] = msgKeyId
    data["msgId"] = msgId
    data["url"] = url
    data["locPath"] = locPath
    data["name"] = name
    data["type"] = type
    data["size"] = size
    data["fileInfo"] = fileInfo
    return data
}

fun NotifyMsg.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["title"] = title
    data["subTitle"] = subTitle
    return data
}

fun ConversationInfo.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["id"] = id
    data["createTime"] = createTime
    data["creator"] = creator
    data["name"] = name
    data["attributes"] = attributes
    data["systemFlag"] = isSystemFlag
    data["msgNotReadCount"] = msgNotReadCount
    data["members"] = members
    data["chatType"] = chatType
    data["memberCount"] = memberCount
    data["muted"] = muted
    data["hide"] = isHide
    data["updateTime"] = updateTime
    data["draft"] = draft
    data["isDisband"] = isDisband
    data["lastMsg"] = convlastMsg?.toMap()
    data["isBeAt"] = isBeAt
    data["headPortrait"] = headPortrait
    data["isTop"] = isTop
    data["isDoNotDisturb"] = isDoNotDisturb
    data["isDriveOut"] = isDriveOut
    data["isEncrypt"] = isEncrypt
    data["timeToBurn"] = timeToBurn
    return data
}

fun MemberInfo.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["clientRemarkName"] = clientRemarkName
    data["headPortrait"] = headPortrait
    data["nickname"] = nickname
    data["clientId"] = clientId
    data["clientAttributes"] = clientAttributes
    data["memberAttributes"] = memberAttributes
    data["role"] = role
    data["muted"] = muted
    return data
}

fun ConvEvent.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["conversationId"] = conversationId
    data["msgId"] = msgId
    data["type"] = type.code
    data["sender"] = sender
    data["operator"] = operator
    data["name"] = name
    data["attributes"] = attributes
    data["passivityOperator"] = passivityOperator
    data["remarkName"] = remarkName
    data["message"] = message?.toMap()
    return data
}

fun RTCEvent.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["subCmd"] = subCmd
    data["conversationId"] = conversationId
    data["callType"] =callType
    data["channelId"] = channelId
    data["timestamp"] = timestamp
    data["clientId"] = clientId
    data["sdpData"] = sdpData
    data["sdpType"] = sdpType
    data["candidateData"] = candidateData
    return data
}

fun ChatRoomMember.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["chatRoomId"] = chatRoomId
    data["clientId"] = clientId
    return data
}

fun TransparentEvent.toMap(): Map<String, Any?> {
    val data: MutableMap<String, Any?> = HashMap()
    data["subCmd"] = subCmd
    data["clientCmd"] = clientCmd
    data["clientId"] = clientId
    data["timestamp"] = timestamp
    data["content"] = content
    data["attribute"] = attribute
    return data
}