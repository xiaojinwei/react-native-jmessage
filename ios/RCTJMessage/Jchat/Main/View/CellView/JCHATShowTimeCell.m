//
//  JCHATShowTimeCell.m
//  JPush IM
//
//  Created by Apple on 15/1/13.
//  Copyright (c) 2015年 Apple. All rights reserved.
//

#import "JCHATShowTimeCell.h"
#import "JCHATStringUtils.h"
#import "UIColor+expanded.h"
#import "UIView+AutoLayout.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width

@implementation JCHATShowTimeCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
     if (self) {
       
     }
    return self;
}
 -(void)setModel:(JCHATChatModel *)model
{
    self.backgroundColor=[UIColor colorWithRed:236/255.0 green:237/255.0 blue:240/255.0 alpha:1];
    _messageTimeLabel.textAlignment=NSTextAlignmentCenter;
    self.messageTimeLabel.font=[UIFont systemFontOfSize:12];
    self.messageTimeLabel.backgroundColor=[UIColor  colorWithHexString:@"0xd6d6d6"];
    self.messageTimeLabel.textColor=[UIColor  colorWithHexString:@"0xffffff"];
   
    NSString *text= [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
    CGSize realSize = [text sizeWithFont:[UIFont systemFontOfSize:12]];
    [self.messageTimeLabel autoSetDimensionsToSize:CGSizeMake(realSize.width+5, realSize.height)];
    [self.messageTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(Screen_Width-realSize.width)/2];
    [self.messageTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(31-realSize.height)/2];
    _messageTimeLabel.layer.cornerRadius = 5;
    _messageTimeLabel.clipsToBounds = YES;
}
-(void)setcellView
{
    _messageTimeLabel=[[UILabel alloc]init];
    [self.contentView addSubview:_messageTimeLabel];
    self.messageTimeLabel.font=[UIFont systemFontOfSize:12];
    self.messageTimeLabel.backgroundColor=[UIColor  colorWithHexString:@"0xd6d6d6"];
    self.messageTimeLabel.textColor=[UIColor  colorWithHexString:@"0xffffff"];
}
@end
