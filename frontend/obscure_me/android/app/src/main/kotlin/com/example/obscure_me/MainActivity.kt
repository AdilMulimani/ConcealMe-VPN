package com.example.obscure_me

import android.content.Intent
import io.flutter.embedding.android.FlutterFragmentActivity
import id.laskarmedia.openvpn_flutter.OpenVPNFlutterPlugin

class MainActivity : FlutterFragmentActivity() {
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        if (requestCode == 24 && resultCode == RESULT_OK) {
            OpenVPNFlutterPlugin.connectWhileGranted(true)
        }
    }
}
