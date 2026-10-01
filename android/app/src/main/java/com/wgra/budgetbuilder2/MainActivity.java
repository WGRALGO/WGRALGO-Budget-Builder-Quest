package com.wgra.budgetbuilder2;

import android.app.AlertDialog;
import android.webkit.WebView;

import com.getcapacitor.BridgeActivity;

public class MainActivity extends BridgeActivity {

    /**
     * Hardware back button:
     *  - first asks the web app to handle it (close a menu sheet, step back in the quest, or go back
     *    to the first step);
     *  - if the web app is already on the first step, confirm before exit.
     */
    @Override
    public void onBackPressed() {
        WebView webView = getBridge() != null ? getBridge().getWebView() : null;
        if (webView == null) {
            super.onBackPressed();
            return;
        }
        webView.evaluateJavascript(
                "(window.onAndroidBack && window.onAndroidBack())",
                value -> {
                    if ("true".equals(value)) {
                        return; // handled inside the app
                    }
                    new AlertDialog.Builder(MainActivity.this)
                            .setTitle("Exit Budget Builder Quest?")
                            .setMessage("Leave the app?")
                            .setPositiveButton("Exit", (d, w) -> finish())
                            .setNegativeButton("Stay", null)
                            .show();
                });
    }
}
