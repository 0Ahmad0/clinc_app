package com.clinic.user;

import android.provider.Settings;
import androidx.annotation.NonNull;
import com.google.firebase.installations.FirebaseInstallations;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String FIREBASE_CHANNEL = "com.clinic.user/firebase_installations";
    private static final String NAVIGATION_CHANNEL = "com.clinic.user/navigation_mode";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

        new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                FIREBASE_CHANNEL
        ).setMethodCallHandler((call, result) -> {
            if (!"deleteFirebaseInstallation".equals(call.method)) {
                result.notImplemented();
                return;
            }

            FirebaseInstallations.getInstance().delete()
                    .addOnSuccessListener(unused -> result.success(null))
                    .addOnFailureListener(error -> result.error(
                            "FIS_DELETE_FAILED",
                            error.getMessage(),
                            null
                    ));
        });

        new MethodChannel(
                flutterEngine.getDartExecutor().getBinaryMessenger(),
                NAVIGATION_CHANNEL
        ).setMethodCallHandler((call, result) -> {
            if (!"is3ButtonNav".equals(call.method)) {
                result.notImplemented();
                return;
            }

            int mode = Settings.Secure.getInt(
                    getContentResolver(),
                    "navigation_mode",
                    2
            );
            result.success(mode == 0);
        });
    }
}
