package cn.wecloud.im.wecloudchatkit_flutter_example

import android.app.Application
import android.app.Notification
import android.app.NotificationManager
import androidx.core.app.NotificationCompat
import cn.wecloud.im.core.im.IMMessageManager
import cn.wecloud.im.core.im.messages.WeMessageType
import cn.wecloud.im.push.AndroidNotificationManager
import cn.wecloud.im.push.PushService
import cn.wecloud.im.wecloudchatkit_flutter_example.msghandler.FileMessageTypeHandler
import cn.wecloud.im.wecloudchatkit_flutter_example.msghandler.ImageMessageTypeHandler
import cn.wecloud.im.wecloudchatkit_flutter_example.msghandler.VideoMessageTypeHandler
import cn.wecloud.im.wecloudchatkit_flutter_example.msghandler.VoiceMessageTypeHandler


class App : Application() {

    companion object {
        var appContext: App? = null
    }



    override fun onCreate() {
        super.onCreate()
        appContext = this
        setupNotify()

        //注册各类型消息的处理
        IMMessageManager.registerMessageTypeHandler(
            WeMessageType.MSG_IMAGE, ImageMessageTypeHandler()
        )
        IMMessageManager.registerMessageTypeHandler(
            WeMessageType.MSG_VIDEO, VideoMessageTypeHandler()
        )
        IMMessageManager.registerMessageTypeHandler(
            WeMessageType.MSG_FILE, FileMessageTypeHandler()
        )
        IMMessageManager.registerMessageTypeHandler(
            WeMessageType.MSG_VOICE, VoiceMessageTypeHandler()
        )
    }

    private fun setupNotify(){
        PushService.setAutoWakeUp(true)
        //创建通知通道
        PushService.createNotificationChannel(
            this,
            "cn.wecloud.im",
            "后台运行",
            "消息渠道",
            NotificationManager.IMPORTANCE_HIGH,
            false,
            0,
            false,
            null
        )
        PushService.setDefaultChannelId(this, AndroidNotificationManager.DEFAULT_CHANNEL_ID)
        PushService.setForegroundMode(true, 123, createForegroundNotification())
        PushService.setDefaultPushCallback(this, MainActivity::class.java)
        PushService.setNotificationIcon(R.mipmap.ic_launcher)
    }

    private fun createForegroundNotification(): Notification {
        val builder =
            NotificationCompat.Builder(this, AndroidNotificationManager.DEFAULT_CHANNEL_ID)
                .setDefaults(NotificationCompat.FLAG_FOREGROUND_SERVICE)
                .setContentTitle("flutter_example")
                .setContentText("后台连接已启用")
                .setPriority(NotificationCompat.PRIORITY_MIN)
                .setVibrate(longArrayOf(0))
                .setSound(null)
        return builder.setOngoing(true)
            .build()
    }
}