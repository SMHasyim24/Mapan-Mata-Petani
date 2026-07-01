package com.example.mapan

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // Force disable wide color gamut to avoid gralloc4 crash on MediaTek/Vivo
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            window.colorMode = android.content.pm.ActivityInfo.COLOR_MODE_DEFAULT
        }
    }

    // Use TextureView instead of SurfaceView to avoid buffer allocation hangs on MediaTek
    override fun getRenderMode(): RenderMode {
        return RenderMode.texture
    }
}
