package com.example.drm_image_demo

import android.app.Activity
import android.graphics.BitmapFactory
import android.view.WindowManager
import android.widget.ImageView

object SecureImageViewer {

 fun show(activity: Activity) {
  activity.window.setFlags(
   WindowManager.LayoutParams.FLAG_SECURE,
   WindowManager.LayoutParams.FLAG_SECURE
  )

  val bitmap = DrmUtils.decrypt(activity)

  val imageView = ImageView(activity)
  imageView.setImageBitmap(bitmap)
  imageView.scaleType = ImageView.ScaleType.FIT_CENTER

  activity.setContentView(imageView)
 }
}
