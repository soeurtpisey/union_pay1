package cn.wecloud.im.wecloudchatkit_flutter_example.msghandler

import cn.wecloud.im.WeCloud
import cn.wecloud.im.core.im.Conversation
import cn.wecloud.im.core.im.IMConversation
import cn.wecloud.im.core.im.MessageTypeHandler
import cn.wecloud.im.core.db.entity.WeMessage

class FileMessageTypeHandler : MessageTypeHandler {

    override fun processEvent(
        conversation: IMConversation?,
        message: WeMessage?,
        operation: Conversation.IMOperation?
    ): WeMessage? {
        if (WeCloud.getClientId() == message?.sender) {
            if (conversation?.isEncrypt == true) {
                MessageHandlerHelper.uploadAndEncryptFile(message)
            }else{
                MessageHandlerHelper.uploadFile(message)
            }
        } else {
            if (conversation?.isEncrypt == true && message?.file?.url != null && message.file?.fileKey != null) {
                MessageHandlerHelper.downloadAndDecryptFile(message)
            }
        }
        return message
    }

}