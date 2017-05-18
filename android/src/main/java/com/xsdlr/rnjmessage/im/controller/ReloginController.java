package com.xsdlr.rnjmessage.im.controller;

import android.app.Activity;
import android.app.Dialog;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;

import com.xsdlr.rnjmessage.R;
import com.xsdlr.rnjmessage.im.activity.ReloginActivity;
import com.xsdlr.rnjmessage.im.chatting.utils.DialogCreator;
import com.xsdlr.rnjmessage.im.chatting.utils.HandleResponseCode;
import com.xsdlr.rnjmessage.im.view.ReloginView;

import cn.jpush.im.android.api.JMessageClient;
import cn.jpush.im.api.BasicCallback;

public class ReloginController implements ReloginView.Listener, OnClickListener {

    private ReloginView mReloginView;
    private ReloginActivity mContext;
    private Dialog mLoadingDialog = null;
    private String mUserName;

    public ReloginController(ReloginView reloginView, ReloginActivity context, String userName) {
        this.mReloginView = reloginView;
        this.mContext = context;
        this.mUserName = userName;
    }



    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
        int viewId = v.getId();
        if (viewId == R.id.relogin_btn){
            //隐藏软键盘
            InputMethodManager manager = ((InputMethodManager) mContext
                    .getSystemService(Activity.INPUT_METHOD_SERVICE));
            if (mContext.getWindow().getAttributes().softInputMode
                    != WindowManager.LayoutParams.SOFT_INPUT_STATE_HIDDEN) {
                if (mContext.getCurrentFocus() != null) {
                    manager.hideSoftInputFromWindow(mContext.getCurrentFocus().getWindowToken(),
                            InputMethodManager.HIDE_NOT_ALWAYS);
                }
            }
            final String password = mReloginView.getPassword();

            if (password.equals("")) {
                mReloginView.passwordError(mContext);
                return;
            }
            mLoadingDialog = DialogCreator.createLoadingDialog(mContext, mContext.getString(R.string.login_hint));
            mLoadingDialog.show();
            JMessageClient.login(mUserName, password, new BasicCallback() {

                @Override
                public void gotResult(final int status, final String desc) {
                    mLoadingDialog.dismiss();
                    if (status == 0) {
                        mContext.startRelogin();
                    } else {
                        HandleResponseCode.onHandle(mContext, status, false);
                    }
                }
            });
        }else if (viewId == R.id.relogin_switch_user_btn){
            mContext.startSwitchUser();
        }else if (viewId == R.id.register_btn){
            mContext.startRegisterActivity();
        }

    }

    @Override
    public void onSoftKeyboardShown(int w, int h, int oldw, int oldh) {
        int softKeyboardHeight = oldh - h;
        if (softKeyboardHeight > 300) {
            mReloginView.setRegisterBtnVisible(View.INVISIBLE);
            mReloginView.setToBottom();
        }else {
            mReloginView.setRegisterBtnVisible(View.VISIBLE);
        }
    }

}
