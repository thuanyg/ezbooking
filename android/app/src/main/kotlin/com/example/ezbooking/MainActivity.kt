package com.thuanht.ezbooking

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "media_scanner"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "scanFile") {
                val path = call.argument<String>("path")
                if (path != null && path.isNotEmpty()) {
                    scanFile(path)
                    result.success("File scanned: $path")
                } else {
                    result.error("INVALID_PATH", "Path is null or empty", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }


    private fun scanFile(path: String) {
        val mediaScanIntent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE)
        val contentUri = Uri.fromFile(File(path))
        mediaScanIntent.data = contentUri
        sendBroadcast(mediaScanIntent)
    }
}
