//
//  RCTJPushModule2.h
//  RCTJMessage
//
//  Created by user on 2017/6/4.
//  Copyright © 2017年 xsdlr. All rights reserved.
//

#import <Foundation/Foundation.h>
#if __has_include(<React/RCTBridgeModule.h>)
#import <React/RCTBridgeModule.h>
#elif __has_include("RCTBridgeModule.h")
#import "RCTBridgeModule.h"
#elif __has_include("React/RCTBridgeModule.h")
#import "React/RCTBridgeModule.h"
#endif
@interface RCTJPushModule : NSObject<RCTBridgeModule>
+ (void)registerWithAppkey:(NSString *)appkey channel:(NSString *)channel launchOptions:(NSDictionary *)launchOptions withApp:(id)app;
+ (void)application:(UIApplication *)application didRegisterDeviceToken:(NSData *)deviceToken;
+ (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
+ (void)didReceiveRemoteNotificationWhenFirstLaunchApp:(NSDictionary *)launchOptions;
@end
