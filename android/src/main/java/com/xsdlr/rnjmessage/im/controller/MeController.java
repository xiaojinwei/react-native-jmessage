package com.xsdlr.rnjmessage.im.controller;

import android.app.Dialog;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;

import com.xsdlr.rnjmessage.R;
import com.xsdlr.rnjmessage.im.activity.MeFragment;
import com.xsdlr.rnjmessage.im.view.MeView;


public class MeController implements OnClickListener {

    private MeView mMeView;
    private MeFragment mContext;
    private Dialog mDialog;
    private int mWidth;

    public MeController(MeView meView, MeFragment context, int width) {
        this.mMeView = meView;
        this.mContext = context;
        this.mWidth = width;
    }

    @Override
    public void onClick(View v) {
        int viewId = v.getId();
        if (viewId == R.id.my_avatar_iv) {
            Log.i("MeController", "avatar onClick");
            mContext.startBrowserAvatar();
        } else if (viewId == R.id.take_photo_iv) {
//                OnClickListener listener = new OnClickListener() {
//                    @Override
//                    public void onClick(View v) {
//                        switch (v.getId()) {
//                            case R.id.jmui_take_photo_btn:
//                                mDialog.cancel();
//                                mContext.takePhoto();
//                                break;
//                            case R.id.jmui_pick_picture_btn:
//                                mDialog.cancel();
//                                mContext.selectImageFromLocal();
//                                break;
//                        }
//                    }
//                };
//                mDialog = DialogCreator.createSetAvatarDialog(mContext.getActivity(), listener);
//                mDialog.show();
//                mDialog.getWindow().setLayout((int) (0.8 * mWidth), WindowManager.LayoutParams.WRAP_CONTENT);
        } else if (viewId == R.id.user_info_rl) {
            mContext.startMeInfoActivity();
        } else if (viewId == R.id.setting_rl) {
            mContext.StartSettingActivity();
        } else if (viewId == R.id.logout_rl) {//退出登录 清除Notification，清除缓存
//                listener = new OnClickListener() {
//                    @Override
//                    public void onClick(View view) {
//                        switch (view.getId()) {
//                            case R.id.jmui_cancel_btn:
//                                mDialog.cancel();
//                                break;
//                            case R.id.jmui_commit_btn:
//                                mContext.Logout();
//                                mContext.cancelNotification();
//                                NativeImageLoader.getInstance().releaseCache();
//                                mContext.getActivity().finish();
//                                mDialog.cancel();
//                                break;
//                        }
//                    }
//                };
//                mDialog = DialogCreator.createLogoutDialog(mContext.getActivity(), listener);
//                mDialog.getWindow().setLayout((int) (0.8 * mWidth), WindowManager.LayoutParams.WRAP_CONTENT);
//                mDialog.show();
        }
    }

}
