package com.kodecraft.pzdeals

import android.content.Intent
import android.os.Bundle
import android.view.Gravity
import android.view.ViewGroup
import androidx.appcompat.app.AppCompatActivity
import com.airbnb.lottie.LottieAnimationView
import android.animation.Animator
import com.airbnb.lottie.LottieDrawable
import android.util.Log
import android.widget.FrameLayout


class SplashActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val animationView = LottieAnimationView(this)
        animationView.setAnimation(R.raw.splash_screen) // Ensure this matches your animation file
        
        // Calculate size to be 60% of the screen
        val screenWidth = resources.displayMetrics.widthPixels
        val size = (screenWidth * 0.6).toInt() // 60% of screen width

        // Create FrameLayout and set layout parameters for centering
        val frameLayout = FrameLayout(this)
        val layoutParams = FrameLayout.LayoutParams(size, size)
        layoutParams.gravity = Gravity.CENTER
        animationView.layoutParams = layoutParams

        // Set animation properties
        animationView.repeatCount = 0 // Play once
        animationView.playAnimation()

        // Add animationView to FrameLayout
        frameLayout.addView(animationView)

        // Set FrameLayout as content view
        setContentView(frameLayout)

        animationView.addAnimatorListener(object : Animator.AnimatorListener {
            override fun onAnimationStart(animation: Animator) {
                Log.d("SplashActivity", "Animation started")
            }

            override fun onAnimationEnd(animation: Animator) {
                Log.d("SplashActivity", "Animation ended")
                startActivity(Intent(this@SplashActivity, MainActivity::class.java))
                finish()
            }

            override fun onAnimationCancel(animation: Animator) {
                Log.d("SplashActivity", "Animation canceled")
            }

            override fun onAnimationRepeat(animation: Animator) {
                Log.d("SplashActivity", "Animation repeated")
            }
        })
    }
}
