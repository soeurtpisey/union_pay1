package cn.wecloud.im.wecloudchatkit_flutter_example.utils

import android.annotation.SuppressLint
import android.util.Log
import com.wecloud.minio_android.MinioClient
import java.io.File
import java.text.SimpleDateFormat
import java.util.*

object MinioUtils {

    private const val TAG = "MinioUtils"

    //    private const val endpoint = "http://121.37.22.224:9000"
    //测试环境
    private const val endpoint = "https://test-file.wecloud.cn"
    private const val accountKey = "test-pwdisZz123456"
    private const val accountSecret = "Zz123456"
    private const val BUCKET_NAME_IM = "wecloudim"
    private const val BUCKET_NAME_FOREVER = "wecloudim-forerver"
    //正式环境
//    private const val endpoint = "https://oss.wecloud.cn/"
//    private const val accountKey = "ee4tXw1pKzdIf0rW"
//    private const val accountSecret = "H8DkFwN3oOsxmVNVZ3ZuQ4iSX40ajehHCHnSPmAaepknGI5qNLulm7QSDPKX4gt4"


    private var minioClientIM: MinioClient? = null
    private var minioClientForever: MinioClient? = null

    fun uploadIMFile(
        clientId: String,
        fileName: String,
        path: String
    ): String? {
        return upload(BUCKET_NAME_IM, clientId, fileName, path)
    }

    fun uploadUserFile(
        clientId: String,
        fileName: String,
        path: String
    ): String? {
        try {
            val url = upload(BUCKET_NAME_FOREVER, clientId, fileName, path)
            return url
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return null
    }

    private fun upload(
        bucketName: String,
        clientId: String,
        fileName: String,
        path: String
    ): String? {
        val file = File(path)
        val minioClient = getClient(bucketName) ?: return null
        val dateStr = getDateTimeByMillisecond(System.currentTimeMillis())
        val objName = "$clientId/other/$dateStr/$fileName"
        minioClient.putObject(bucketName, objName, path, file.length(), null, null, null)
        return minioClient.presignedGetObject(bucketName, objName)
    }

    private fun getClient(bucketName: String): MinioClient? {
        if (BUCKET_NAME_FOREVER == bucketName) {
            if (minioClientForever == null)
                minioClientForever = createClient(BUCKET_NAME_FOREVER)
            return minioClientForever
        } else {
            if (minioClientIM == null)
                minioClientIM = createClient(BUCKET_NAME_IM)
            return minioClientIM
        }
    }

    private fun createClient(bucketName: String): MinioClient? {
        var minioClient: MinioClient? = null
        try {
            minioClient = MinioClient(endpoint, accountKey, accountSecret)
            val found = minioClient.bucketExists(bucketName)
            if (found != true) {
                // 如果不存在则创建
                minioClient.makeBucket(bucketName)
            } else {
                Log.e(TAG, "Bucket [$bucketName] already exists.");
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return minioClient
    }

    @SuppressLint("SimpleDateFormat")
    private fun getDateTimeByMillisecond(timeMillis: Long): String? {
        val date = Date(timeMillis)
        val format = SimpleDateFormat("yyyy-MM-w")
        return format.format(date)
    }
}