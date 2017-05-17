//
//  JCHATShowTimeCell.h
//  JPush IM
//
//  Created by Apple on 15/1/13.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCHATChatModel.h"

@interface JCHATShowTimeCell : UITableViewCell
@property (strong, nonatomic) UILabel*messageTimeLabel;
@property (strong, nonatomic) JCHATChatModel *model;
@property(nonatomic,strong)NSString*timeMessage;
- (void)setCellData :(JCHATChatModel *)model;
- (void)layoutErrorMessage;
@end
