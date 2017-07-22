import {
    NativeModules,
    Platform,
    NativeEventEmitter,
    DeviceEventEmitter, //android
    NativeAppEventEmitter, //ios
} from 'react-native';
import Base64 from 'base-64';
import { requsetMediaURL } from './lib/restApi';
import camelcaseKeys from 'camelcase-keys';
import {cloneDeep, isEmpty} from 'lodash';

const JMessageModule = NativeModules.JMessageModule;

export default class JMessage {
    static eventEmitter = Platform.OS==='ios'?NativeAppEventEmitter:DeviceEventEmitter;
    static appKey = JMessageModule.AppKey;
    static masterSecret = JMessageModule.MasterSecret;
    static authKey = Base64.encode(`${JMessageModule.AppKey}:${JMessageModule.MasterSecret}`);

    static events = {
        "onReceiveMessage": "onReceiveMessage",
        "onJGSendMessage": "onJGSendMessage",
        "onReadMessageBack": "onReadMessageBack",
        "onNotificationClickEvent":"onNotificationClickEvent",
    };
    static addOnReadMessageBack(cb) {
        return JMessage.addEventListener('onReadMessageBack', cb)
    }

    static addReceiveMessageListener(cb) {
        // return JMessage.eventEmitter.addListener('onReceiveMessage', (message) => {
        //     console.log('onReceiveMessage===',message);
        //     const _message = formatMessage(message);
        //     supportMessageMediaURL(_message).then((message) => cb(message));
        // });
        return JMessage.addEventListener('onReceiveMessage', (message) => {
            console.log('addSendMessageListener===',message);
            const _message = formatMessage(message);
            supportMessageMediaURL(_message).then((message) => cb(message));
        })
    }
    static addNotificationClickEvent(cb) {
        return JMessage.addEventListener('onNotificationClickEvent', (message) => {
            console.log('onNotificationClickEvent===',message);
            const _message = formatMessage(message);
            supportMessageMediaURL(_message).then((message) => cb(message));
        })
    }
    static removeAllListener(eventNames = Object.keys(JMessage.events)) {
        if (Array.isArray(eventNames)) {
            for ( eventName of eventNames) {
                console.log('eventName=====',eventName)
                JMessage.eventEmitter.removeAllListeners(eventName);
            }
        } else {
            console.log('eventName===22222==',eventNames)
            JMessage.eventEmitter.removeAllListeners(eventNames);
        }
    }
    static addSendMessageListener(cb) {
        return JMessage.addEventListener('onJGSendMessage', (message) => {
            console.log('addSendMessageListener===',message);
            const _message = formatMessage(message);
            supportMessageMediaURL(_message).then((message) => cb(message));
        })
        // return JMessage.eventEmitter.addListener('onSendMessage', (message) => {
        //     console.log('addSendMessageListener===',message);
        //     const _message = formatMessage(message);
        //     supportMessageMediaURL(_message).then((message) => cb(message));
        // });
    }
    static addEventListener(eventName: string, handler: Function) {
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
    }
    
    static init() {
        if (Platform.OS === 'android') {
            JMessageModule.setupJMessage();
        }
    }
    static isLoggedIn() {
        return JMessageModule.isLoggedIn();
    }

    /***
     * 修改用户信息
     * userFieldType:
     /// 用户信息字段: 用户名
     kJMSGUserFieldsNickname = 0,
     /// 用户信息字段: 生日
     kJMSGUserFieldsBirthday = 1,
     /// 用户信息字段: 签名
     kJMSGUserFieldsSignature = 2,
     /// 用户信息字段: 性别
     kJMSGUserFieldsGender = 3,
     /// 用户信息字段: 区域
     kJMSGUserFieldsRegion = 4,
     /// 用户信息字段: 头像 (内部定义的 media_id)
     kJMSGUserFieldsAvatar = 5,

     * @param parameter 要修改的值
     * @param kJMSGUserFieldsGender 要修改的key
     * @returns {*}
     */
    static updateMyInfoWithParameter(parameter,kJMSGUserFields){
        return JMessageModule.updateMyInfoWithParameter(parameter,kJMSGUserFields)

    }
    static myInfo() {
        return JMessageModule.myInfo().then((info) => {
            const {avatar} = info;
            if(avatar) {
                return requsetMediaURL(JMessage.authKey, avatar).then((data) => {
                    return {...info, ...{avatar: data.url}};
                })
            } else {
                return info;
            }
        });
    }
    static login(username, password) {
        return JMessageModule.login(username, password).then((info) => {
            const {avatar} = info;
            if(avatar) {
                return requsetMediaURL(JMessage.authKey, avatar).then((data) => {
                    return {...info, ...{avatar: data.url}};
                })
            } else {
                return info;
            }
        });
    }
    static register(username, password) {
        return JMessageModule.register(username, password).then((info) => {
                return info;
        });
    }
    static async registerAndLogin(username, password){
        let loginInfo = {}
        try{
            loginInfo = await JMessage.login(username, password)
        }catch(err){
            console.log('err===aaaaaa',err.code)
            if(err.code==='801003'){
                try {
                    await JMessage.register(username, password)
                    return await JMessage.login(username, password)
                }catch (err){
                    throw err
                }
            }else{
                throw err
            }
        }


        return JMessageModule.login(username, password).then((info) => {
            const {avatar} = info;
            if(avatar) {
                return requsetMediaURL(JMessage.authKey, avatar).then((data) => {
                    return {...info, ...{avatar: data.url}};
                })
            } else {
                return info;
            }
        });
    }
    static logout() {
        return JMessageModule.logout();
    }
    static sendSingleMessage({name, type, data={}}) {
        return JMessageModule.sendSingleMessage(name, type, data)
            .then(message => formatMessage(message));
    }
    static sendGroupMessage({gid, type, data={}}) {
        return JMessageModule.sendGroupMessage(gid, type, data)
            .then(message => formatMessage(message));
    }
    static sendMessageByCID({cid, type, data={}}) {
        return JMessageModule.sendMessageByCID(cid, type, data)
            .then(message => formatMessage(message));
    }
    static allConversations() {
        return JMessageModule.allConversations();
    }
    static historyMessages(cid, offset=0, limit=0) {
        return JMessageModule.historyMessages(cid, offset, limit)
            .then(messages => Promise.all(messages.map((message) => {
                const _message = formatMessage(message);
                return supportMessageMediaURL(_message);
            })));
    }
    static clearUnreadCount(cid) {
        return JMessageModule.clearUnreadCount(cid);
    }
    static removeConversation(cid) {
        return JMessageModule.removeConversation(cid);
    }
    static toChatpage(userName,appKey,isSingle){
        return JMessageModule.toChatpage(userName,appKey,isSingle);
    }
}

const supportMessageMediaURL = (message) => {
    console.log('supportMessageMediaURL',message);
    const {content = {}, from = {}, target = {}} = message;
    const requsetMediaURLPromise = mid => requsetMediaURL(JMessage.authKey, mid);
    return Promise
        .resolve(message)
        .then(message => requsetMediaURLPromise(from.avatar).then((data) => {
            message.from.mediaLink = data.url;
            return message;
        }).catch(() => message))
        .then(message => requsetMediaURLPromise(target.avatar).then((data) => {
            message.target.mediaLink = data.url;
            return message;
        }).catch(() => message))
        .then(message => requsetMediaURLPromise(content.mediaId).then((data) => {
            message.content.mediaLink = data.url;
            return message;
        }).catch(() => message));
};

const formatMessage = (message) => {
    if(message){
        const _message = cloneDeep(message)
        try {
            _message.content = JSON.parse(_message.content);
        } catch (ex) {
            _message.contentJSONString = _message.content;
            _message.content = {};
        }
        return camelcaseKeys(_message, {deep: true});
    }
    return ''
};