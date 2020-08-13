package com.xsdlr.rnjmessage.im.controller;

import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.provider.MediaStore;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;


import androidx.fragment.app.Fragment;
import androidx.viewpager.widget.ViewPager;

import com.xsdlr.rnjmessage.R;
import com.xsdlr.rnjmessage.im.Contracts;
import com.xsdlr.rnjmessage.im.activity.ChatMainActivity;
import com.xsdlr.rnjmessage.im.activity.ConversationListFragment;
import com.xsdlr.rnjmessage.im.activity.MeFragment;
import com.xsdlr.rnjmessage.im.adapter.ViewPagerAdapter;
import com.xsdlr.rnjmessage.im.chatting.utils.HandleResponseCode;
import com.xsdlr.rnjmessage.im.view.MainView;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import cn.jpush.im.android.api.JMessageClient;
import cn.jpush.im.api.BasicCallback;

public class MainController implements OnClickListener, ViewPager.OnPageChangeListener {

    private final static String TAG = "MainController";

    private ConversationListFragment mConvListFragment;

    private MeFragment mMeActivity;
    private MainView mMainView;
//    private ContactsFragment mContactsActivity;

    private ChatMainActivity mContext;
    private ProgressDialog mDialog;
    // 裁剪后图片的宽(X)和高(Y), 720 X 720的正方形。
    private static int OUTPUT_X = 720;
    private static int OUTPUT_Y = 720;

    public MainController(MainView mMainView, ChatMainActivity context) {
        this.mMainView = mMainView;
        this.mContext = context;
        setViewPager();
    }

    private void setViewPager() {
        List<Fragment> fragments = new ArrayList<Fragment>();
        // init Fragment
        mConvListFragment = new ConversationListFragment();
//        mContactsActivity = new ContactsFragment();
        mMeActivity = new MeFragment();
        fragments.add(mConvListFragment);
//        fragments.add(mConvListFragment);
        fragments.add(mMeActivity);
        ViewPagerAdapter viewPagerAdapter = new ViewPagerAdapter(mContext.getSupportFragmentManger(),
                fragments);
        mMainView.setViewPagerAdapter(viewPagerAdapter);
    }

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
        int viewId = v.getId();
        if (viewId == R.id.actionbar_msg_btn){
            mMainView.setCurrentItem(0);
//        }else if (viewId == R.id.actionbar_contact_btn){
//            mMainView.setCurrentItem(1);
        }else if (viewId == R.id.actionbar_me_btn){
            mMainView.setCurrentItem(1);
        }
    }

    public String getPhotoPath() {
        return mMeActivity.getPhotoPath();
    }

    /**
     * 裁剪图片
     */
    public void cropRawPhoto(Uri uri) {

        Intent intent = new Intent("com.android.camera.action.CROP");
        intent.setDataAndType(uri, "image/*");

        // 设置裁剪
        intent.putExtra("crop", "true");

        // aspectX , aspectY :宽高的比例
        intent.putExtra("aspectX", 1);
        intent.putExtra("aspectY", 1);
        // outputX , outputY : 裁剪图片宽高
        intent.putExtra("outputX", OUTPUT_X);
        intent.putExtra("outputY", OUTPUT_Y);
        intent.putExtra("return-data", false);
        intent.putExtra("outputFormat", Bitmap.CompressFormat.PNG.toString());
        intent.putExtra(MediaStore.EXTRA_OUTPUT, uri);
        mContext.startActivityForResult(intent, Contracts.REQUEST_CODE_CROP_PICTURE);
    }

    public void uploadUserAvatar(final String path) {
        mDialog = new ProgressDialog(mContext);
        mDialog.setCanceledOnTouchOutside(false);
        mDialog.setMessage(mContext.getString(R.string.updating_avatar_hint));
        mDialog.show();
        JMessageClient.updateUserAvatar(new File(path), new BasicCallback() {
            @Override
            public void gotResult(final int status, final String desc) {
                mDialog.dismiss();
                if (status == 0) {
                    Log.i(TAG, "Update avatar succeed path " + path);
                    loadUserAvatar(path);
                //如果头像上传失败，删除剪裁后的文件
                }else {
                    HandleResponseCode.onHandle(mContext, status, false);
                    File file = new File(path);
                    if (file.delete()) {
                        Log.d(TAG, "Upload failed, delete cropped file succeed");
                    }
                }
            }
        });
    }

    private void loadUserAvatar(String path) {
        if (path != null)
            mMeActivity.loadUserAvatar(path);
    }

    @Override
    public void onPageSelected(int index) {
        // TODO Auto-generated method stub
        mMainView.setButtonColor(index);
    }

    @Override
    public void onPageScrollStateChanged(int arg0) {
        // TODO Auto-generated method stub

    }

    @Override
    public void onPageScrolled(int arg0, float arg1, int arg2) {
        // TODO Auto-generated method stub

    }

    public void sortConvList() {
        mConvListFragment.sortConvList();
    }

    public void refreshNickname(String newName) {
        mMeActivity.refreshNickname(newName);
    }
}
