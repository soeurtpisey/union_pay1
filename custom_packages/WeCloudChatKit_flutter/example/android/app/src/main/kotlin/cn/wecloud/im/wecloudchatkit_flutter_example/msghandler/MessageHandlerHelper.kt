package cn.wecloud.im.wecloudchatkit_flutter_example.msghandler

import cn.wecloud.im.WeCloud
import cn.wecloud.im.core.db.entity.WeMessage
import cn.wecloud.im.signal.utils.AESFileUtils
import cn.wecloud.im.wecloudchatkit_flutter_example.App
import cn.wecloud.im.wecloudchatkit_flutter_example.download.DownloadManager
import cn.wecloud.im.wecloudchatkit_flutter_example.utils.FileUtils
import cn.wecloud.im.wecloudchatkit_flutter_example.utils.MinioUtils
import java.io.File

object MessageHandlerHelper {

    fun uploadFile(message: WeMessage?) {
        val path = message?.file?.locPath
        if (path != null) {
            val fileName = message.reqId + FileUtils.getFileExtension(path)
            message.reqId
            val url = MinioUtils.uploadIMFile(WeCloud.getClientId(), fileName, path)
            message.file?.url = url
        }
    }

    fun uploadAndEncryptFile(message: WeMessage?) {
        val path = message?.file?.locPath
        if (path != null) {
            val tempFileName = "pass_" + System.currentTimeMillis()
            val outputPath =
                App.appContext?.cacheDir.toString() + File.separator + tempFileName
            val fileKey = AESFileUtils.encryptFile(path, outputPath)
            val url =
                MinioUtils.uploadIMFile(WeCloud.getClientId(), tempFileName, outputPath)
            message.file?.url = url
            message.file?.fileKey = fileKey
        }
    }


    fun downloadAndDecryptFile(message: WeMessage?) {
        //下载加密文件
        val tempFileName = "pass_" + System.currentTimeMillis()
        val tempOutputPath = App.appContext?.cacheDir.toString()
        val downloadFile = DownloadManager.getInstance()
            .downloadFile(message?.file?.url!!, tempFileName, tempOutputPath)
        //解密文件
        val fileKey = message.file?.fileKey!!
        val downloadDir = getDownloadFileDir().absolutePath + File.separator + message.file?.name
        AESFileUtils.decryptFile(fileKey, downloadFile, downloadDir)
        message.file?.locPath = downloadDir
    }

    private fun getDownloadFileDir(): File {
        return File(getBackUpDir(), "Download").dir()
    }

    private fun getBackUpDir(): File {
        return File(getBaseDir(), ".BackUp").dir()
    }

    private fun getBaseDir(): File? {
        return App.appContext?.getExternalFilesDir("wecloudIm")
    }

    private fun File.dir(): File {
        if (!exists()) {
            mkdirs()
        }
        return this
    }
}