//
//  UINib_ext.h
//  RCTJMessage
//
//  Created by user on 2017/5/19.
//  Copyright © 2017年 xsdlr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UINib_ext:NSObject
+ (UINib *)nibWithNibName:(NSString *)name bundle:(nullable NSBundle *)bundleOrNil;

// If the bundle parameter is nil, the main bundle is used.
+ (UINib *)nibWithData:(NSData *)data bundle:(nullable NSBundle *)bundleOrNil;
@end
