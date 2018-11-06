
import React, {
    NativeModules,
    DeviceEventEmitter, //android
    NativeAppEventEmitter, //ios
    Platform,
    AppState,
} from 'react-native';

import headlessJsTask from './headlessTask';

const JPushModule = NativeModules.JPushModule;
var receiveMessageSubscript, openMessageSubscription,receiveNotificationSubscript;

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
    setTags(tags){
        JPushModule.setTags(tags)
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
    clearAllNotifications() {
        return JPushModule.clearAllNotifications();
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
    didReceiveNotification(handler: Function) {
        if(Platform.OS === 'android') {
            receiveNotificationSubscript = this.addEventListener(JPushModule.DidReceiveNotification, message => {
                console.log('didReceiveNotification-->message:',message)
                //处于后台时，拦截收到的通知
                if(AppState.currentState === 'background') {
                    return;
                }
                handler(message);
            });
        }
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
    removeListener(eventName){
        if(Platform.OS === 'android') {
            return DeviceEventEmitter.removeAllListeners(eventName)
        }
        else {
            return NativeAppEventEmitter.removeAllListeners(eventName)
        }
    },
    removeAllListeners(){
        this.removeListener(JPushModule.DidOpenMessage)
        this.removeListener(JPushModule.DidReceiveMessage)
    },
}