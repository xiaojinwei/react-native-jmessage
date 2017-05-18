package com.xsdlr.rnjmessage.im.controller;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.CompoundButton;


import com.xsdlr.rnjmessage.R;
import com.xsdlr.rnjmessage.im.activity.LoginActivity;
import com.xsdlr.rnjmessage.im.chatting.utils.DialogCreator;
import com.xsdlr.rnjmessage.im.chatting.utils.HandleResponseCode;
import com.xsdlr.rnjmessage.im.chatting.utils.SharePreferenceManager;
import com.xsdlr.rnjmessage.im.view.LoginView;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import cn.jpush.im.android.api.JMessageClient;
import cn.jpush.im.api.BasicCallback;

public class LoginController implements LoginView.Listener, OnClickListener,
        CompoundButton.OnCheckedChangeListener {

    private LoginView mLoginView;
    private LoginActivity mContext;

    public LoginController(LoginView mLoginView, LoginActivity context) {
        this.mLoginView = mLoginView;
        this.mContext = context;
    }

    @Override
    public void onClick(View v) {
        int viewId = v.getId();
        if (viewId == R.id.return_btn){
            mContext.finish();
        }else if (viewId == R.id.login_btn){//隐藏软键盘
            InputMethodManager manager = ((InputMethodManager) mContext
                    .getSystemService(Activity.INPUT_METHOD_SERVICE));
            if (mContext.getWindow().getAttributes().softInputMode
                    != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
                if (mContext.getCurrentFocus() != null) {
                    manager.hideSoftInputFromWindow(mContext.getCurrentFocus().getWindowToken(),
                            InputMethodManager.HIDE_NOT_ALWAYS);
                }
            }

            final String userId = mLoginView.getUserId();
            final String password = mLoginView.getPassword();

            if (userId.equals("")) {
                mLoginView.userNameError(mContext);
                return;
            } else if (password.equals("")) {
                mLoginView.passwordError(mContext);
                return;
            }
            final Dialog dialog = DialogCreator.createLoadingDialog(mContext,
                    mContext.getString(R.string.login_hint));
            dialog.show();
            JMessageClient.login(userId, password, new BasicCallback() {
                @Override
                public void gotResult(final int status, final String desc) {
                    dialog.dismiss();
                    if (status == 0) {
                        String username = JMessageClient.getMyInfo().getUserName();
                        String appKey = JMessageClient.getMyInfo().getAppKey();
//                            UserEntry user = UserEntry.getUser(username, appKey);
//                            if (null == user) {
//                                user = new UserEntry(username, appKey);
//                                user.save();
//                            }
                        mContext.startMainActivity();
                    } else {
                        Log.i("LoginController", "status = " + status);
                        HandleResponseCode.onHandle(mContext, status, false);
                    }
                }
            });
        }else if (viewId == R.id.register_btn){
            mContext.startRegisterActivity();
        }

    }

    @Override
    public void onSoftKeyboardShown(int w, int h, int oldw, int oldh) {
        int softKeyboardHeight = oldh - h;
        if (softKeyboardHeight > 300) {
            mLoginView.setRegistBtnVisable(View.INVISIBLE);
            boolean writable = SharePreferenceManager.getCachedWritableFlag();
            if (writable) {
                Log.i("LoginController", "commit h: " + softKeyboardHeight);
                SharePreferenceManager.setCachedKeyboardHeight(softKeyboardHeight);
                SharePreferenceManager.setCachedWritableFlag(false);
            }
        }else {
            mLoginView.setRegistBtnVisable(View.VISIBLE);
        }
    }


    @Override
    public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
        Log.d("sdfs", "onCheckedChanged !!!! isChecked = " + isChecked);
        if (isChecked) {
            swapEnvironment(true);
        } else {
            swapEnvironment(false);
        }
    }

    private void swapEnvironment(boolean isTest) {
        try {
            Method method = JMessageClient.class.getDeclaredMethod("swapEnvironment", Context.class, Boolean.class);
            method.invoke(null, mContext, isTest);
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }

}
