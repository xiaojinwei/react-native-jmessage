package com.xsdlr.rnjpush;

import android.content.Context;
import android.content.SharedPreferences;


/**
 * Created by chenyongjian on 2016/2/19.
 */
public class SharePreferencesUtil {
    public static final String DEFAULT_SHARE_NODE = "default_sharepreference";

    public static void saveInt(Context context,String key, int value) {
        SharedPreferences sp = context.getSharedPreferences(DEFAULT_SHARE_NODE, Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sp.edit();
        editor.putInt(key, value);
        editor.commit();
    }


    public static int getInt(Context context,String key, int defaultvalue) {
        SharedPreferences sp = context.getSharedPreferences(DEFAULT_SHARE_NODE, Context.MODE_PRIVATE);
        return sp.getInt(key, defaultvalue);
    }



}
