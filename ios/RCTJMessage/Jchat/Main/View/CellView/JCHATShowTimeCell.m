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
    _messageTimeLabel=[[UILabel alloc]init];
    [self.contentView addSubview:_messageTimeLabel];
    _messageTimeLabel.textAlignment=NSTextAlignmentCenter;
    self.messageTimeLabel.font=[UIFont systemFontOfSize:12];
   self.messageTimeLabel.backgroundColor=[UIColor  colorWithHexString:@"0xd6d6d6"];
    self.messageTimeLabel.textColor=[UIColor  colorWithHexString:@"0xffffff"];
    self.messageTimeLabel.numberOfLines=0;
    NSString *text= [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
     if (model.isErrorMessage) {
        text = [NSString stringWithFormat:@"接收消息错误 错误码:%ld",model.messageError.code];
    }
    if (model.message.contentType == kJMSGContentTypeEventNotification) {
        text = [((JMSGEventContent *)model.message.content) showEventNotification]
        ;
    }
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width-150, 2000);
    UIFont *font =[UIFont systemFontOfSize:16];
    NSMutableParagraphStyle *paragraphStyle= [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:8];
    CGSize realSize = [text boundingRectWithSize:maxSize options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle} context:nil].size;
    [self.messageTimeLabel autoSetDimensionsToSize:CGSizeMake(realSize.width, realSize.height)];
    [self.messageTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(Screen_Width-realSize.width)/2];
    if (model.isTime) {
        [self.messageTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(31-realSize.height)/2];
    }else{
        [self.messageTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(model.contentHeight+17-realSize.height)/2];
    }
    self.messageTimeLabel.text=text;
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
