package com.xsdlr.rnjmessage.im.activity;

import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.GridView;
import android.widget.ImageButton;

import com.facebook.drawee.backends.pipeline.Fresco;
import com.xsdlr.rnjmessage.R;
import com.xsdlr.rnjmessage.im.Contracts;
import com.xsdlr.rnjmessage.im.adapter.PickPictureAdapter;
import com.xsdlr.rnjmessage.im.chatting.utils.BitmapLoader;
import com.xsdlr.rnjmessage.im.chatting.utils.HandleResponseCode;

import java.io.File;
import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;

import cn.jpush.im.android.api.JMessageClient;
import cn.jpush.im.android.api.content.ImageContent;
import cn.jpush.im.android.api.model.Conversation;
import cn.jpush.im.android.api.model.Message;

public class PickPictureActivity extends BaseActivity {

    private GridView mGridView;
    //此相册下所有图片的路径集合
    private List<String> mList;
    //选中图片的路径集合
    private List<String> mPickedList;
    private Button mSendPictureBtn;
    private ImageButton mReturnBtn;
    private boolean mIsGroup = false;
    private PickPictureAdapter mAdapter;
    private String mTargetId;
    private String mTargetAppKey;
    private Conversation mConv;
    private ProgressDialog mDialog;
    private long mGroupId;
    private int[] mMsgIds;
    private static final int SEND_PICTURE = 200;
    private final MyHandler myHandler = new MyHandler(this);
    private int mIndex = 0;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_pick_picture_detail);
        mSendPictureBtn = (Button) findViewById(R.id.pick_picture_send_btn);
        mReturnBtn = (ImageButton) findViewById(R.id.return_btn);
        mGridView = (GridView) findViewById(R.id.child_grid);

        Intent intent = this.getIntent();
        mGroupId = intent.getLongExtra(Contracts.GROUP_ID, 0);
        if (mGroupId != 0) {
            mIsGroup = true;
            mConv = JMessageClient.getGroupConversation(mGroupId);
        } else {
            mTargetId = intent.getStringExtra(Contracts.TARGET_ID);
            mTargetAppKey = intent.getStringExtra(Contracts.TARGET_APP_KEY);
            mConv = JMessageClient.getSingleConversation(mTargetId, mTargetAppKey);
        }
        mList = intent.getStringArrayListExtra("data");
        mAdapter = new PickPictureAdapter(this, mList, mGridView, mDensity);
        mGridView.setAdapter(mAdapter);
        mGridView.setOnItemClickListener(onItemListener);
        mSendPictureBtn.setOnClickListener(listener);
        mReturnBtn.setOnClickListener(listener);
        mGridView.setOnScrollListener(new AbsListView.OnScrollListener() {
            @Override
            public void onScrollStateChanged(AbsListView view, int scrollState) {
                if (scrollState == SCROLL_STATE_FLING) {

                    Fresco.getImagePipeline().pause();
//                    Picasso.with(view.getContext()).pauseTag(TAG);
                } else {
                    Fresco.getImagePipeline().resume();
//                    Picasso.with(view.getContext()).resumeTag(TAG);
                }
            }

            @Override
            public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {

            }
        });
    }

    private OnItemClickListener onItemListener = new OnItemClickListener() {
        @Override
        public void onItemClick(AdapterView<?> viewAdapter, View view, int position, long id) {
            Intent intent = new Intent();
            intent.putExtra("fromChatActivity", false);
            if (mIsGroup) {
                intent.putExtra(Contracts.GROUP_ID, mGroupId);
            } else {
                intent.putExtra(Contracts.TARGET_ID, mTargetId);
                intent.putExtra(Contracts.TARGET_APP_KEY, mTargetAppKey);
            }
            intent.putStringArrayListExtra("pathList", (ArrayList<String>) mList);
            intent.putExtra(Contracts.POSITION, position);
            intent.putExtra("pathArray", mAdapter.getSelectedArray());
            intent.setClass(PickPictureActivity.this, BrowserViewPagerActivity.class);
            startActivityForResult(intent, Contracts.REQUEST_CODE_BROWSER_PICTURE);
        }
    };

    private OnClickListener listener = new OnClickListener() {
        @Override
        public void onClick(View v) {
            int viewId = v.getId();
            if (viewId == R.id.pick_picture_send_btn){//点击发送按钮，发送选中的图片
                //存放选中图片的路径
                mPickedList = new ArrayList<String>();
                //存放选中的图片的position
                List<Integer> positionList;
                positionList = mAdapter.getSelectItems();
                //拿到选中图片的路径
                for (int i = 0; i < positionList.size(); i++) {
                    mPickedList.add(mList.get(positionList.get(i)));
                }
                if (mPickedList.size() < 1) {
                    return;
                } else {
                    mDialog = new ProgressDialog(PickPictureActivity.this);
                    mDialog.setCanceledOnTouchOutside(false);
                    mDialog.setCancelable(false);
                    mDialog.setMessage(PickPictureActivity.this.getString(R.string.sending_hint));
                    mDialog.show();

                    getThumbnailPictures();
                }
            }else if (viewId == R.id.return_btn){
                finish();
            }
        }

    };

    /**
     * 获得选中图片的缩略图路径
     */
    private void getThumbnailPictures() {
        mMsgIds = new int[mPickedList.size()];
        Bitmap bitmap;
        for (int i = 0; i < mPickedList.size(); i++) {
            if (BitmapLoader.verifyPictureSize(mPickedList.get(i))) {
                File file = new File(mPickedList.get(i));
                ImageContent.createImageContentAsync(file, new ImageContent.CreateImageContentCallback() {
                    @Override
                    public void gotResult(int status, String desc, ImageContent imageContent) {
                        if (status == 0) {
                            Message msg = mConv.createSendMessage(imageContent);
                            mMsgIds[mIndex] = msg.getId();
                        } else {
                            mMsgIds[mIndex] = -1;
                            HandleResponseCode.onHandle(PickPictureActivity.this, status, false);
                        }
                        mIndex++;
                        if (mIndex >= mPickedList.size()) {
                            myHandler.sendEmptyMessage(SEND_PICTURE);
                        }
                    }
                });
            } else {
                bitmap = BitmapLoader.getBitmapFromFile(mPickedList.get(i), 720, 1280);
                ImageContent.createImageContentAsync(bitmap, new ImageContent.CreateImageContentCallback() {
                    @Override
                    public void gotResult(int status, String desc, ImageContent imageContent) {
                        if (status == 0) {
                            Message msg = mConv.createSendMessage(imageContent);
                            mMsgIds[mIndex] = msg.getId();
                        } else {
                            mMsgIds[mIndex] = -1;
                            HandleResponseCode.onHandle(PickPictureActivity.this, status, false);
                        }
                        mIndex++;
                        if (mIndex >= mPickedList.size()) {
                            myHandler.sendEmptyMessage(SEND_PICTURE);
                        }
                    }
                });
            }
        }
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        if (resultCode == Contracts.RESULT_CODE_SELECT_PICTURE) {
            if (data != null) {
                int[] selectedArray = data.getIntArrayExtra("pathArray");
                int sum = 0;
                for (int i : selectedArray) {
                    if (i > 0) {
                        ++sum;
                    }
                }
                if (sum > 0) {
                    String sendText = PickPictureActivity.this.getString(R.string.jmui_send) + "(" + sum + "/" + "9)";
                    mSendPictureBtn.setText(sendText);
                } else {
                    mSendPictureBtn.setText(PickPictureActivity.this.getString(R.string.jmui_send));
                }
                mAdapter.refresh(selectedArray);
            }

        } else if (resultCode == Contracts.RESULT_CODE_BROWSER_PICTURE) {
            setResult(Contracts.RESULT_CODE_SELECT_ALBUM, data);
            finish();
        }
    }

    private static class MyHandler extends Handler {
        private final WeakReference<PickPictureActivity> mActivity;

        public MyHandler(PickPictureActivity activity) {
            mActivity = new WeakReference<PickPictureActivity>(activity);
        }

        @Override
        public void handleMessage(android.os.Message msg) {
            super.handleMessage(msg);
            PickPictureActivity activity = mActivity.get();
            if (activity != null) {
                switch (msg.what) {
                    case SEND_PICTURE:
                        Intent intent = new Intent();
                        intent.putExtra(Contracts.MsgIDs, activity.mMsgIds);
                        activity.setResult(Contracts.RESULT_CODE_SELECT_ALBUM, intent);
                        if (activity.mDialog != null) {
                            activity.mDialog.dismiss();
                        }
                        activity.finish();
                        break;
                }
            }
        }
    }
}
