package cn.wecloud.im.wecloudchatkit_flutter_example.download

import io.reactivex.disposables.Disposable

class DownloadTask {
    var disposable: Disposable? = null
    var localFilePath: String? = null
    private val listeners = arrayListOf<DownloadListener>()

    fun cancel() {
        if (listeners.isEmpty()) {
            disposable?.dispose()
        }
        localFilePath = null
        listeners.clear()
    }

    fun register(listener: DownloadListener) {
        listeners.add(listener)
    }

    fun remove(listener: DownloadListener) {
        listeners.remove(listener)
    }

    fun loadFailure(message: String) {
        listeners.forEach {
            it.onFail(message)
        }
    }

    fun progress(progress: Long, max: Long) {
        listeners.forEach {
            it.onProgress(progress, max)
        }
    }

    fun loadSuccess() {
        listeners.forEach {
            it.onSuccess(localFilePath ?: "")
        }
    }
}