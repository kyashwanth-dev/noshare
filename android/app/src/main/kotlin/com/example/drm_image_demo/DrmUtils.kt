package com.example.drm_image_demo

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import java.io.File
import javax.crypto.Cipher
import javax.crypto.spec.IvParameterSpec
import javax.crypto.spec.SecretKeySpec

object DrmUtils {

 fun decrypt(context: Context): Bitmap {
  val encFile = File(context.filesDir, "secret.enc")
  val keyFile = File(context.filesDir, "key.bin")

  val enc = encFile.readBytes()
  val key = keyFile.readBytes()

  val iv = enc.copyOfRange(0, 16)
  val data = enc.copyOfRange(16, enc.size)

  val cipher = Cipher.getInstance("AES/CBC/PKCS5Padding")
  cipher.init(
   Cipher.DECRYPT_MODE,
   SecretKeySpec(key, "AES"),
   IvParameterSpec(iv)
  )

  val bytes = cipher.doFinal(data)
  return BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
 }
}
