package com.xsdlr.rnjmessage;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.xsdlr.rnjpush.JPushModule;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Created by xsdlr on 2016/12/14.
 */
public class JMessagePackage implements ReactPackage {
    public JMessagePackage(boolean isDebug) {
        super();
        JMessageModule.isDebug = isDebug;
    }

    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        return Arrays.asList(new NativeModule[]{
                new JMessageModule(reactContext),
                new JPushModule(reactContext)
        });
    }

    @Override
    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return null;
    }


    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Collections.emptyList();
    }
}
