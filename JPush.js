
import React, {
    NativeModules,
    DeviceEventEmitter, //android
    NativeAppEventEmitter, //ios
    Platform,
    AppState,
} from 'react-native';

import headlessJsTask from './headlessTask';

const JPushModule = NativeModules.JPushModule;
var receiveMessageSubscript, openMessageSubscription;

module.exports = JPush= {
    // setAppkeyAndSecret(key:String,secret:String) {
    //     JPushModule.setAppkeyAndSecret(key,secret);
    // },
    // addAlias(alias:String,type:String) {
    //     JPushModule.addAlias(alias,type);
    // },
    initPush() {
        JPushModule.initPush();
    },
    setAlias(alias:String) {
        console.log('inter setAlias');
        JPushModule.setAlias(alias);
    },

    removeAlias(alias:String) {
        JPushModule.setAlias('');
    },

    getDeviceToken(handler: Function) {
        JPushModule.getDeviceToken(handler);
    },
    /**
     * Android 关闭推送
     */
    stopPush() {
        JPushModule.stopPush();
    },

    /**
     * Android 开启推送
     */
    resumePush() {
        JPushModule.resumePush();
    },
    isPushStopped() {
        return JPushModule.isPushStopped();
    },
    toNotificationSetPage(){
        return JPushModule.toNotificationSetPage();
    },
    didReceiveMessage(handler: Function) {
        receiveMessageSubscript = this.addEventListener(JPushModule.DidReceiveMessage, message => {
            console.log('didReceiveMessage-->message:'+message.toString())
            //处于后台时，拦截收到的消息
            if(AppState.currentState === 'background') {
                return;
            }
            handler(message);
        });
    },

    didOpenMessage(handler: Function) {
        openMessageSubscription = this.addEventListener(JPushModule.DidOpenMessage, handler);
    },

    addEventListener(eventName: string, handler: Function) {
        if(Platform.OS === 'android') {
            return DeviceEventEmitter.addListener(eventName, (event) => {
                handler(event);
            });
        }
        else {
            return NativeAppEventEmitter.addListener(
                eventName, (userInfo) => {
                    handler(userInfo);
                });
        }
    },
}