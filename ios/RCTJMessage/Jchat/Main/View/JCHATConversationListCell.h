//
//  JCHATConversationListCell.h
//  DecorateTogether
//
//  Created by 张羽 on 16/10/9.
//  Copyright © 2016年 Aiken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JMessage/JMessage.h"

@interface JCHATConversationListCell : UITableViewCell
@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *NameLabel;
@property(nonatomic,strong)UILabel *MessageLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)JMSGConversation*JMSGConversation;
@property(nonatomic,copy)NSDictionary *messageDic;
@property(nonatomic,strong)UIButton *unReadNumbelLabel;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end
