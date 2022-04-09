package io.edr.shazamkit.reactnative;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.*;
import com.facebook.react.module.annotations.ReactModule;

@ReactModule(name = ShazamKitModule.NAME)
public class ShazamKitModule extends ReactContextBaseJavaModule {
    public static final String NAME = "ShazamKit";

    public ShazamKitModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    @NonNull
    public String getName() {
        return NAME;
    }

    @ReactMethod
    public void isSupported(String empty, Promise promise) {
      promise.resolve(false);
    }

    @ReactMethod
    public void listen(String empty, Promise promise) {
      promise.reject("ERR_PLATFORM_UNSUPPORTED", "Android is not supported by ShazamKit.");
    }

    @ReactMethod
    public void stop(String empty, Promise promise) {
      promise.reject("ERR_PLATFORM_UNSUPPORTED", "Android is not supported by ShazamKit.");
    }
}
