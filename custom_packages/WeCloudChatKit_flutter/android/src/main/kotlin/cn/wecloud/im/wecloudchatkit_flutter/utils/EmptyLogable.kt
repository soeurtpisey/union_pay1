package cn.wecloud.im.wecloudchatkit_flutter.utils

import com.zhangke.websocket.util.Logable

class EmptyLogable : Logable {
    override fun v(p0: String?, p1: String?) {

    }

    override fun v(p0: String?, p1: String?, p2: Throwable?) {
    }

    override fun d(p0: String?, p1: String?) {
    }

    override fun d(p0: String?, p1: String?, p2: Throwable?) {
    }

    override fun i(p0: String?, p1: String?) {
    }

    override fun i(p0: String?, p1: String?, p2: Throwable?) {
    }

    override fun e(p0: String?, p1: String?) {
    }

    override fun e(p0: String?, p1: String?, p2: Throwable?) {
    }

    override fun w(p0: String?, p1: Throwable?) {
    }

    override fun wtf(p0: String?, p1: String?) {
    }

    override fun wtf(p0: String?, p1: Throwable?) {
    }

    override fun wtf(p0: String?, p1: String?, p2: Throwable?) {
    }
}