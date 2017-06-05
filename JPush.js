
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
    setAlias(alias:String) {
        JPushModule.setAlias(alias);
    },

    removeAlias(alias:String) {
        JPushModule.removeAlias(alias);
    },

    getDeviceToken(handler: Function) {
        JPushModule.getDeviceToken(handler);
    },

    didReceiveMessage(handler: Function) {
        receiveMessageSubscript = this.addEventListener(JPushModule.DidReceiveMessage, message => {
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