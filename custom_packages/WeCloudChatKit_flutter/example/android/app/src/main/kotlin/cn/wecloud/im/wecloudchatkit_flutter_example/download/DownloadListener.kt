package cn.wecloud.im.wecloudchatkit_flutter_example.download

interface DownloadListener {
    fun onProgress(progress: Long, max: Long)
    fun onSuccess(localPath: String)
    fun onFail(errorInfo: String)
}