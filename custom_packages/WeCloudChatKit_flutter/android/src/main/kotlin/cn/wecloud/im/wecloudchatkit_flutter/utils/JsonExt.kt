package cn.wecloud.im.wecloudchatkit_flutter.utils

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken


fun <T> String.toBeanList():List<T> = Gson().fromJson(this,object: TypeToken<List<T>>(){}.type)
