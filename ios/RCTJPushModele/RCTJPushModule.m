//
//  RCTUmengPush.m
//  RCTUmengPush
//
//  Created by user on 16/4/24.
//  Copyright © 2016年 react-native-umeng-push. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCTJPushModule.h"
#import "JPUSHService.h"
#import "RCTEventDispatcher.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

static NSString * const DidReceiveMessage = @"DidReceiveMessage";
static NSString * const DidOpenMessage = @"DidOpenMessage";
static RCTJPushModule *_instance = nil;

@interface RCTJPushModule ()
@property (nonatomic, copy) NSString *deviceToken;
@end
@implementation RCTJPushModule

@synthesize bridge = _bridge;
RCT_EXPORT_MODULE()

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [[self alloc] init];
        }
    });
    return _instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(_instance == nil) {
            _instance = [super allocWithZone:zone];
            
        }
    });
    return _instance;
}

+ (dispatch_queue_t)sharedMethodQueue {
    static dispatch_queue_t methodQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        methodQueue = dispatch_queue_create("com.liuchungui.react-native-jpush", DISPATCH_QUEUE_SERIAL);
    });
    return methodQueue;
}

- (dispatch_queue_t)methodQueue {
    return [RCTJPushModule sharedMethodQueue];
}

- (NSDictionary<NSString *, id> *)constantsToExport {
    return @{
             DidReceiveMessage: DidReceiveMessage,
             DidOpenMessage: DidOpenMessage,
             };
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self.bridge.eventDispatcher sendAppEventWithName:DidReceiveMessage body:userInfo];
}

- (void)didOpenRemoteNotification:(NSDictionary *)userInfo {
    [self.bridge.eventDispatcher sendAppEventWithName:DidOpenMessage body:userInfo];
}



RCT_EXPORT_METHOD(getDeviceToken:(RCTResponseSenderBlock)callback) {
    NSString *deviceToken = self.deviceToken;
    if(deviceToken == nil) {
        deviceToken = @"";
    }
    callback(@[deviceToken]);
}

+ (void)registerWithlaunchOptions:(NSDictionary *)launchOptions withApp:(id)app {
    
    NSString *appKey = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NativeConfig" ofType:@".plist"]] objectForKey:@"JiguangAppKey"];
    NSString *appChannel = [[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NativeConfig" ofType:@".plist"]] objectForKey:@"JiguangAppChannel"];
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:app];
        
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
   
#ifdef DEBUG
    [JPUSHService setDebugMode];
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:@"dev" apsForProduction:false];
#else
    [JPUSHService setLogOFF];
    [JPUSHService setupWithOption:launchOptions appKey:appKey
                          channel:@"appstore" apsForProduction:true];
#endif
}



RCT_EXPORT_METHOD(setAlias:(NSString *)alias){
    [JPUSHService setAlias:alias callbackSelector:nil object:nil];
}
RCT_EXPORT_METHOD(removeAlias:(NSString *)alias type:(NSString *)type){
    [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
}
RCT_EXPORT_METHOD(isPushStopped:(RCTPromiseResolveBlock)resolve
                  :(RCTPromiseRejectBlock)reject){
    resolve(@([[UIApplication sharedApplication] currentUserNotificationSettings].types  == UIRemoteNotificationTypeNone));
}
RCT_EXPORT_METHOD(toNotificationSetPage){
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
}
+ (void)application:(UIApplication *)application didRegisterDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}

+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
//    //send event
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [[RCTJPushModule sharedInstance] didReceiveRemoteNotification:userInfo];
    }
    else {
        [[RCTJPushModule sharedInstance] didOpenRemoteNotification:userInfo];
    }
    [JPUSHService handleRemoteNotification:userInfo];
}

+ (void)didReceiveRemoteNotificationWhenFirstLaunchApp:(NSDictionary *)launchOptions {
    if(launchOptions){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), [self sharedMethodQueue], ^{
            //判断当前模块是否正在加载，已经加载成功，则发送事件
            if(![RCTJPushModule sharedInstance].bridge.isLoading) {
                [JPUSHService handleRemoteNotification:launchOptions];
                [[RCTJPushModule sharedInstance] didOpenRemoteNotification:launchOptions];
            }
            else {
                [self didReceiveRemoteNotificationWhenFirstLaunchApp:launchOptions];
            }
        });
    }
    
}
+(void)setBadgeNumber:(int)badge{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badge];
    [JPUSHService setBadge:badge];
}
@end
