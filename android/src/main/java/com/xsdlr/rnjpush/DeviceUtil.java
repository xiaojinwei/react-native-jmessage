package com.xsdlr.rnjpush;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.text.TextUtils;

/**
 * Created by abc on 2017/6/26.
 */

public class DeviceUtil {
    private static String mCurrentLauncherName;
    public static boolean isXiaoMi(Context context) {
        if (TextUtils.isEmpty(mCurrentLauncherName)) {
            mCurrentLauncherName = getCurrentLaunchname(context);
        }
        boolean isConain = false;
        if (mCurrentLauncherName.contains("Xiaomi")) {
            return true;
        }

        if (mCurrentLauncherName.contains("miui")) {
            return true;
        }
        return false;
    }

    public static String getCurrentLaunchname(Context context) {
        Intent intent = new Intent(Intent.ACTION_MAIN);
        intent.addCategory(Intent.CATEGORY_HOME);
        ResolveInfo resolveInfo = context.getPackageManager().resolveActivity(intent, PackageManager.MATCH_DEFAULT_ONLY);

        if (resolveInfo == null || resolveInfo.activityInfo.name.toLowerCase().contains("resolver"))
            return "";

        return resolveInfo.activityInfo.packageName;
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
}
