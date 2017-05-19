//
//  UINib_ext.m
//  RCTJMessage
//
//  Created by user on 2017/5/19.
//  Copyright © 2017年 xsdlr. All rights reserved.
//

#import "UINib_ext.h"
@implementation UINib_ext
+ (UINib *)nibWithNibName:(NSString *)name bundle:(nullable NSBundle *)bundleOrNil{
    
    if(bundleOrNil){
        return [UINib nibWithNibName:name bundle:bundleOrNil];
    }else{
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"RCTJMessageBundle" withExtension:@"bundle"]];
        return [UINib nibWithNibName:name bundle:bundleOrNil];
    }
    
}
+ (UINib *)nibWithData:(NSData *)data bundle:(nullable NSBundle *)bundleOrNil{
    if(bundleOrNil){
        return [UINib nibWithData:data bundle:bundleOrNil];
    }else{
        NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"RCTJMessageBundle" withExtension:@"bundle"]];
        return [UINib nibWithData:data bundle:bundleOrNil];
    }
}

@end
