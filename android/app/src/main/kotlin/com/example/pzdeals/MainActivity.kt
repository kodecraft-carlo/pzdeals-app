package com.kodecraft.pzdeals

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "app.channel.shared.data"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getDeepLink") {
                val intent: Intent = intent
                val deepLink: String? = intent.dataString
                if (deepLink != null) {
                    result.success(deepLink)
                } else {
                    result.error("UNAVAILABLE", "Deep link not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
