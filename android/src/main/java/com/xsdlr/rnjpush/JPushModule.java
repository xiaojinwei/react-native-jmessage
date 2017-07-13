package com.xsdlr.rnjpush;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.text.TextUtils;

import com.facebook.react.bridge.Arguments;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;

import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CountDownLatch;

import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.TagAliasCallback;
import me.leolin.shortcutbadger.ShortcutBadger;

public class JPushModule extends ReactContextBaseJavaModule {

    private static String TAG = "JPushModule";
    private Context mContext;
    private static ReactApplicationContext mRAC;
    private static CountDownLatch mLatch;

    protected static final String DidReceiveMessage = "DidReceiveMessage";
    protected static final String DidOpenMessage = "DidOpenMessage";

    public JPushModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mLatch = new CountDownLatch(1);
    }

    @Override
    public boolean canOverrideExistingModule() {
        return true;
    }

    @Override
    public String getName() {
        return "JPushModule";
    }

    @Override
    public void initialize() {
        super.initialize();
        mLatch.countDown();
        mRAC = getReactApplicationContext();
        DeviceUtil.removeCount(this.getReactApplicationContext());
    }

    @Override
    public void onCatalystInstanceDestroy() {
        super.onCatalystInstanceDestroy();
    }

    @Override
    public Map<String, Object> getConstants() {
        final Map<String, Object> constants = new HashMap<>();
        constants.put(DidReceiveMessage, DidReceiveMessage);
        constants.put(DidOpenMessage, DidOpenMessage);
        return constants;

    }

    @ReactMethod
    public void initPush() {
        mContext = getCurrentActivity();
        JPushInterface.init(getReactApplicationContext());
        Logger.toast(mContext, "Init push success");
        Logger.i(TAG, "init Success!");
    }



    @ReactMethod
    public void stopPush() {
        mContext = getCurrentActivity();
        JPushInterface.stopPush(getReactApplicationContext());
        Logger.i(TAG, "Stop push");
        Logger.toast(mContext, "Stop push success");
    }

    @ReactMethod
    public void resumePush() {
        mContext = getCurrentActivity();
        JPushInterface.resumePush(getReactApplicationContext());
        Logger.i(TAG, "Resume push");
        Logger.toast(mContext, "Resume push success");
    }
    @ReactMethod
    public void isPushStopped(final Promise promise) {
        mContext = getCurrentActivity();
        boolean isPushStopped = JPushInterface.isPushStopped(getReactApplicationContext());
        promise.resolve(isPushStopped);
        Logger.i(TAG, "isPushStopped:"+isPushStopped);
//        Logger.toast(mContext, "isPushStopped:"+isPushStopped);
    }


    /**
     * Set alias. This API is covering logic rather then incremental logic, means call this API will cover alias
     * that have been set before. See document: https://docs.jiguang.cn/jpush/client/Android/android_api/#api_3
     * for detail.
     *
     * @param str      alias string.
     * @param
     */
    @ReactMethod
    public void setAlias(String str) {
        mContext = getCurrentActivity();
        final String alias = str.trim();
        Logger.i(TAG, "alias: " + alias);
        if (!TextUtils.isEmpty(alias)) {
            JPushInterface.setAlias(getReactApplicationContext(), alias,
                    new TagAliasCallback() {
                        @Override
                        public void gotResult(int status, String desc, Set<String> set) {
                            switch (status) {
                                case 0:
                                    Logger.i(TAG, "Set alias success");
                                    Logger.toast(getReactApplicationContext(), "Set alias success");
//                                    callback.invoke(0);
                                    break;
                                case 6002:
                                    Logger.i(TAG, "Set alias timeout");
                                    Logger.toast(getReactApplicationContext(),
                                            "set alias timeout, check your network");
//                                    callback.invoke("Set alias timeout");
                                    break;
                                default:
                                    Logger.toast(getReactApplicationContext(), "Error code: " + status);
//                                    callback.invoke("Set alias failed. Error code: " + status);
                            }
                        }
                    });
        } else {
            Logger.toast(mContext, "Empty alias ");
            Logger.i(TAG, "Empty alias, will cancel early alias setting");
            JPushInterface.setAlias(getReactApplicationContext(), "", new TagAliasCallback() {
                @Override
                public void gotResult(int status, String desc, Set<String> set) {
                    switch (status) {
                        case 0:
                            Logger.i(TAG, "Cancel alias success");
                            Logger.toast(getReactApplicationContext(), "Cancel alias success");
//                            callback.invoke(0);
                            break;
                        case 6002:
                            Logger.i(TAG, "Set alias timeout");
                            Logger.toast(getReactApplicationContext(),
                                    "set alias timeout, check your network");
//                            callback.invoke("Set alias timeout");
                            break;
                        default:
                            Logger.toast(getReactApplicationContext(), "Error code: " + status);
//                            callback.invoke("Set alias failed. Error code: " + status);
                    }
                }
            });
        }
    }

    /**
     *
     * 获取设备id/registrationId
     * @param callback
     */
    @ReactMethod
    public void getDeviceToken(Callback callback) {
        try {
            mContext = getCurrentActivity();
            String id = JPushInterface.getRegistrationID(mContext);
            callback.invoke(id);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * 接收自定义消息,通知,通知点击事件等事件的广播
     * 文档链接:http://docs.jiguang.cn/client/android_api/
     */
    public static class JPushReceiver extends BroadcastReceiver {

        public JPushReceiver() {
        }

        @Override
        public void onReceive(Context context, Intent data) {
            Bundle bundle = data.getExtras();
            if (JPushInterface.ACTION_MESSAGE_RECEIVED.equals(data.getAction())) {
                DeviceUtil.applyCount(context);
                String message = data.getStringExtra(JPushInterface.EXTRA_MESSAGE);
                String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
                WritableMap map = Arguments.createMap();
                map.putString("message", message);
                map.putString("extras", extras);
                Logger.i(TAG, "收到自定义消息: " + message);
                sendEvent(DidReceiveMessage, map, null);
            } else if (JPushInterface.ACTION_NOTIFICATION_RECEIVED.equals(data.getAction())) {
                try {
                    DeviceUtil.applyCount(context);
                    // 通知内容
                    String alertContent = bundle.getString(JPushInterface.EXTRA_ALERT);
                    // extra 字段的 json 字符串
                    String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
                    Logger.i(TAG, "收到推送下来的通知: " + alertContent);
//                    if (!isApplicationRunning(context)) {
                    // HeadlessService 启动有问题，暂时弃用了
//                        Log.i(TAG, "应用尚未切换到前台运行过，启动 HeadlessService");
//                        Intent intent = new Intent(context, HeadlessService.class);
//                        intent.putExtra("data", bundle);
//                        context.startService(intent);
//                        HeadlessJsTaskService.acquireWakeLockNow(context);
                    // Save as local notification
                    // Start up application failed, will save notifications as local notifications.
//                    }
                    WritableMap map = Arguments.createMap();
                    map.putString("alertContent", alertContent);
                    map.putString("extras", extras);
                    sendEvent(DidReceiveMessage, map, null);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                // 这里点击通知跳转到指定的界面可以定制化一下
            } else if (JPushInterface.ACTION_NOTIFICATION_OPENED.equals(data.getAction())) {
                try {
                    Logger.d(TAG, "用户点击打开了通知");
                    // 通知内容
                    String alertContent = bundle.getString(JPushInterface.EXTRA_ALERT);
                    // extra 字段的 json 字符串
                    String extras = bundle.getString(JPushInterface.EXTRA_EXTRA);
                    WritableMap map = Arguments.createMap();
                    map.putString("alertContent", alertContent);
                    map.putString("extras", extras);
                    map.putString("jumpTo", "second");
                    // judge if application is running in background, opening initial Activity.
                    // You can change here to open appointed Activity. All you need to do is create
                    // the appointed Activity, and use JS render the appointed Activity.
                    // Please reference examples' SecondActivity for detail,
                    // and JS files are in folder: example/react-native-android
                    Intent intent = new Intent();
                    String package_path = getAppMetaData(context,"package_path");
                    intent.setClassName(context.getPackageName(), package_path+".MainActivity");
                    intent.putExtras(bundle);
                    intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TOP);
                    context.startActivity(intent);
                    // 如果需要跳转到指定的界面，那么需要同时启动 MainActivity 及指定界面：
                    // If you need to open appointed Activity, you need to start MainActivity and
                    // appointed Activity at the same time.
//                    Intent detailIntent = new Intent();
//                    detailIntent.setClassName(context.getPackageName(), context.getPackageName() + ".SecondActivity");
//                    detailIntent.putExtras(bundle);
//                    Intent[] intents = {intent, detailIntent};
                    // 同时启动 MainActivity 以及 SecondActivity
//                    context.startActivities(intents);
                    sendEvent(DidOpenMessage, map, null);
                } catch (Exception e) {
                    e.printStackTrace();
                    Logger.i(TAG, "Shouldn't access here");
                }
                // 应用注册完成后会发送广播，在 JS 中 JPushModule.addGetRegistrationIdListener 接口可以第一时间得到 registrationId
                // After JPush finished registering, will send this broadcast, use JPushModule.addGetRegistrationIdListener
                // to get registrationId in the first instance.
            } else if (JPushInterface.ACTION_REGISTRATION_ID.equals(data.getAction())) {
                String registrationId = data.getExtras().getString(JPushInterface.EXTRA_REGISTRATION_ID);
                Logger.d(TAG, "注册成功, registrationId: " + registrationId);
                try {
                    sendEvent("getRegistrationId", null, registrationId);
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        }

    }

    /**
     * 获取application中指定的meta-data
     * @return 如果没有获取成功(没有对应值，或者异常)，则返回值为空
     */
    public static String getAppMetaData(Context ctx, String key) {
        if (ctx == null || TextUtils.isEmpty(key)) {
            return null;
        }
        String resultData = null;
        try {
            PackageManager packageManager = ctx.getPackageManager();
            if (packageManager != null) {
                ApplicationInfo applicationInfo = packageManager.getApplicationInfo(ctx.getPackageName(), PackageManager.GET_META_DATA);
                if (applicationInfo != null) {
                    if (applicationInfo.metaData != null) {
                        resultData = applicationInfo.metaData.getString(key);
                    }else{
                        return ctx.getPackageName();
                    }
                }

            }
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }

        return resultData;
    }

    private static void sendEvent(String methodName, WritableMap map, String data) {
        try {
            mLatch.await();
            if (mRAC != null) {
                if (map != null) {
                    mRAC.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(methodName, map);
                } else {
                    mRAC.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class)
                            .emit(methodName, data);
                }
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
