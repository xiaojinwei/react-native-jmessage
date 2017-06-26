package com.xsdlr.rnjpush;

import android.content.Context;
import android.content.Intent;
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
}
