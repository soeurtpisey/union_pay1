package cn.wecloud.im.wecloudchatkit_flutter_example.msghandler

import cn.wecloud.im.WeCloud
import cn.wecloud.im.core.im.Conversation
import cn.wecloud.im.core.im.IMConversation
import cn.wecloud.im.core.im.MessageTypeHandler
import cn.wecloud.im.core.db.entity.WeMessage

class VideoMessageTypeHandler : MessageTypeHandler {

    val videoUrl = "https://v1.kwaicdn.com/upic/2021/12/09/18/BMjAyMTEyMDkxODMyMDRfNDMxNjIxMTIzXzYyNDE4MzYwODkzXzFfMw==_b_Bee7ccd1df809d3d41a1984ae25026885.mp4?pkey=AAUelB6iysup6b5vrYGbB0fFZmuhIhxeDY0aNoLLCocVpH8zNUd4HGDrT66AYdOGFE5tUwpF4ah_ZzAgJX9KePbVb_wF25pWTlJzu1LPPwxjAFLRGgeDKjCNR_BaSmJjCRg&tag=1-1642318353-xpcwebdetail-0-wroerh2cmg-65f53a1959e6c528&clientCacheKey=3xqhu9iias58tt4_b.mp4&tt=b&di=7824fb5a&bp=10004"
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