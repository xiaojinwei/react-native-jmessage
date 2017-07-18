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
    self.messageTimeLabel.layer.cornerRadius=5.0;
    self.messageTimeLabel.clipsToBounds=YES;
    NSString *text= [JCHATStringUtils getFriendlyDateString:[model.messageTime longLongValue]];
     if (model.isErrorMessage) {
        text = [NSString stringWithFormat:@"接收消息错误 错误码:%ld",model.messageError.code];
    }
    if (model.message.contentType == kJMSGContentTypeEventNotification) {
        text = [((JMSGEventContent *)model.message.content) showEventNotification]
        ;
    }
    if (model.isTime) {
        CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:12]];
        [self.messageTimeLabel autoSetDimensionsToSize:CGSizeMake(size.width+10, size.height+5)];
        [self.messageTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(31-size.height-5)/2];
        [self.messageTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(Screen_Width-size.width-10)/2];
    }else if(model.message.contentType == kJMSGContentTypeEventNotification)
    {
        self.messageTimeLabel.font=[UIFont systemFontOfSize:14];
        [self.messageTimeLabel autoSetDimensionsToSize:CGSizeMake(model.contentSize.width, model.contentSize.height+5)];
        [self.messageTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(Screen_Width-model.contentSize.width)/2];
        [self.messageTimeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:(model.contentHeight+17-model.contentSize.height-5)/2];
        
        
    }else{
        
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
