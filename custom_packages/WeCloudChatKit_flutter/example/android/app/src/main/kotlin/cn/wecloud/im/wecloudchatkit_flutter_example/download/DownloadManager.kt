package cn.wecloud.im.wecloudchatkit_flutter_example.download

import io.reactivex.Observable
import io.reactivex.disposables.Disposable
import io.reactivex.schedulers.Schedulers
import okhttp3.OkHttpClient
import okhttp3.Request
import java.io.File
import java.io.FileOutputStream
import java.io.InputStream
import java.net.ConnectException
import java.text.SimpleDateFormat
import java.util.*
import java.util.concurrent.atomic.AtomicReference

class DownloadManager {

    private var mClient: OkHttpClient = OkHttpClient.Builder().build()
    private var taskMap = HashMap<String, DownloadTask>() //用来存放各个下载的请求

    class Progress(val progress: Long, val max: Long)

    companion object {
        private val INSTANCE = AtomicReference<DownloadManager>()
        fun getInstance(): DownloadManager {
            while (true) {
                var current: DownloadManager? = INSTANCE.get()
                if (current != null) {
                    return current
                }
                current = DownloadManager()
                if (INSTANCE.compareAndSet(null, current)) {
                    return current
                }
            }
        }
    }


    /**
     * 开始下载
     * @param url 下载请求的网址
     * @param dirPath 本地保存文件夹目录
     */
    fun download(
        url: String,
        fileName: String,
        dirPath: String,
        downloadListener: DownloadListener?
    ): Disposable {
        val task = taskMap[url] ?: DownloadTask()
        downloadListener?.let { task.register(it) }
        if (task.disposable != null) return task.disposable!!

        val disposable = Observable.create<Progress> {
            val request = Request.Builder().url(url).build()
            val response = mClient.newCall(request).execute()
            if (!response.isSuccessful) {
                throw ConnectException()
            }
            val contentLength = response.body?.contentLength() ?: 0
            if (contentLength == 0L) {
                throw Exception("无效的文件")
            }
            val localFile = File(getLocalPath(dirPath, fileName))
            var inputStream: InputStream? = null
            var fileOutputStream: FileOutputStream? = null
            try {
                inputStream = response.body?.byteStream()
                fileOutputStream = FileOutputStream(localFile, true)
                val buffer = ByteArray(2048)//缓冲数组2kB

                var downloadLength = 0L
                var len: Int = inputStream!!.read(buffer)
                while (len != -1) {
                    fileOutputStream.write(buffer, 0, len)
                    downloadLength += len.toLong()
                    it.onNext(Progress(downloadLength, contentLength))
                    len = inputStream.read(buffer)
                }
                fileOutputStream.flush()
                task.localFilePath = localFile.path
                it.onComplete()
            } finally {
                //关闭IO流
                inputStream?.close()
                fileOutputStream?.close()
            }
        }
            .doOnDispose {
                task.loadFailure("任务取消")
                cancelDownload(url)
            }
//            .compose(SchedulerUtils.ioToMain())
            .subscribeOn(Schedulers.io())
            .observeOn(Schedulers.trampoline())
            .subscribe({
                task.progress(it.progress, it.max)
            }, {
                task.loadFailure(it.message ?: "下载失败")
                cancelDownload(url)
            }, {
                task.loadSuccess()
                cancelDownload(url)
            })
        task.disposable = disposable
        return disposable
    }

    fun downloadFile(url: String, fileName: String, dirPath: String): String {
        val request = Request.Builder().url(url).build()
        val response = mClient.newCall(request).execute()
        if (!response.isSuccessful) {
            throw ConnectException()
        }
        val contentLength = response.body?.contentLength() ?: 0
        if (contentLength == 0L) {
            throw Exception("无效的文件")
        }
        val localFile = File(getLocalPath(dirPath, fileName))
        var inputStream: InputStream? = null
        var fileOutputStream: FileOutputStream? = null
        try {
            inputStream = response.body?.byteStream()
            fileOutputStream = FileOutputStream(localFile, true)
            val buffer = ByteArray(2048)//缓冲数组2kB

            var downloadLength = 0L
            var len: Int = inputStream!!.read(buffer)
            while (len != -1) {
                fileOutputStream.write(buffer, 0, len)
                downloadLength += len.toLong()
                len = inputStream.read(buffer)
            }
            fileOutputStream.flush()
            return localFile.path
        } finally {
            //关闭IO流
            inputStream?.close()
            fileOutputStream?.close()
        }
    }


    /**
     * 取消下载 删除本地文件
     * @param url 下载地址
     */
    fun cancelDownload(url: String) {
        taskMap.remove(url)?.cancel()
    }


    /**
     *
     * 如果文件已下载重新命名新文件名
     * @param dir 要保存到本地的文件目录
     * @param url 后台的下载文件路径
     * @return
     */
    private fun getLocalPath(dir: String, downFileName: String): String {
        //@TODO 后台返回的下载url不一定能拿到正确的文件名，到时候需要自行处理
        val date = Calendar.getInstance().time
        val timeStr = date.format("yyyy-MM-dd-HHmmss")
        //从下载url截取到的文件名称
        //var fileName = url.substring(url.lastIndexOf("/"))
        var fileName = timeStr
        //保存到本地的文件目录名称
        var file =
            File("$dir${File.separator}$fileName${downFileName}")
        fileName = fileName.substringBeforeLast(".")
        //这里有坑，后台返回的下载链接不一定有后缀
        val ext = file.extension
        var i = 1
        while (file.exists()) {
            file = File("$dir${File.separator}$fileName($i).${ext}")
            i++
        }
        return file.path
    }


    fun Date.format(format: String = "yyyy-MM-dd HH:mm:ss"): String {
        return SimpleDateFormat(format, Locale.CHINA).format(this)
    }
}