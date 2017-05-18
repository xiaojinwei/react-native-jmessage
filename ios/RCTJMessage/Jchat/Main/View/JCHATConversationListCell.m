//
//  JCHATConversationListCell.m
//  DecorateTogether
//
//  Created by 张羽 on 16/10/9.
//  Copyright © 2016年 Aiken. All rights reserved.
//

#import "JCHATConversationListCell.h"
#import "JCHATStringUtils.h"
#import "UIView+AutoLayout.h"
#import "UIColor+expanded.h"
#define Screen_Width [UIScreen mainScreen].bounds.size.width
@implementation JCHATConversationListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
           }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setJMSGConversation:(JMSGConversation *)JMSGConversation
{
    [self setcellView];
    _NameLabel.text=JMSGConversation.title;
    _MessageLabel.text=[JMSGConversation latestMessageContentText];
    [JMSGConversation avatarData:^(NSData *data, NSString *objectId, NSError *error) {
        UIImage*image=[UIImage imageWithData:data];
        _iconImage.image=image;
        if (!data) {
         
         
       _iconImage.image = [UIImage imageNamed:@"RCTJMessageBundle.bundle/headDefalt.png"];
          
        }
    }];
    _iconImage.layer.cornerRadius=5.0;
    _iconImage.layer.masksToBounds= YES;
    if (JMSGConversation.latestMessage.timestamp != nil ) {
        double time = [JMSGConversation.latestMessage.timestamp doubleValue];
        _timeLabel.text = [JCHATStringUtils getFriendlyDateString:time forConversation:YES];
    } else {
         _timeLabel.text = @"";
    }
    if ([JMSGConversation.unreadCount integerValue]>0) {
        _unReadNumbelLabel.hidden=NO;
        NSString *messageNum=[NSString stringWithFormat:@"%@", JMSGConversation.unreadCount];
        _unReadNumbelLabel.titleLabel.textAlignment=NSTextAlignmentCenter;
        if (messageNum.length==1) {
            [_unReadNumbelLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:-10];
            [_unReadNumbelLabel autoSetDimensionsToSize:CGSizeMake(15, 15)];
            
            _unReadNumbelLabel.layer.cornerRadius=7.5;
        }else if(messageNum.length==2){
            [_unReadNumbelLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:-15];
            [_unReadNumbelLabel autoSetDimensionsToSize:CGSizeMake(20, 20)];
            
            _unReadNumbelLabel.layer.cornerRadius=10;
        }else{
            messageNum=@"99+";
            [_unReadNumbelLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:-20];
            [_unReadNumbelLabel autoSetDimensionsToSize:CGSizeMake(25, 20)];
            
            _unReadNumbelLabel.layer.cornerRadius=10;
            
        }
       [_unReadNumbelLabel setTitle:messageNum forState:UIControlStateNormal];
    }else{
        _unReadNumbelLabel.hidden=YES;
    }
}
-(void)setMessageDic:(NSDictionary *)messageDic
{
//    NSString *time=[NSString stringWithFormat:@"%@",messageDic[@"date"]];
    [self setcellView];
    NSString*messageNum=[NSString stringWithFormat:@"%@",messageDic[@"messageNum"]];
    if ([messageNum intValue]>0) {
        
        _unReadNumbelLabel.hidden=NO;
        _unReadNumbelLabel.titleLabel.textAlignment=NSTextAlignmentCenter;
        if (messageNum.length==1) {
             [_unReadNumbelLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:-10];
            [_unReadNumbelLabel autoSetDimensionsToSize:CGSizeMake(15, 15)];
            
            _unReadNumbelLabel.layer.cornerRadius=7.5;
        }else if(messageNum.length==2){
             [_unReadNumbelLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:-15];
            [_unReadNumbelLabel autoSetDimensionsToSize:CGSizeMake(20, 20)];
            
            _unReadNumbelLabel.layer.cornerRadius=10;
        }else{
             messageNum=@"99+";
             [_unReadNumbelLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:-20];
            [_unReadNumbelLabel autoSetDimensionsToSize:CGSizeMake(25, 20)];
            
            _unReadNumbelLabel.layer.cornerRadius=10;
            
        }
         [_unReadNumbelLabel setTitle:messageNum forState:UIControlStateNormal];

    }else{
        _unReadNumbelLabel.hidden=YES;
    }
    _timeLabel.text=messageDic[@"date"];
    _MessageLabel.text=messageDic[@"content"];
    if (self.indexPath.row==0) {
        _NameLabel.text=@"交易通知";
        _iconImage.image=[UIImage imageNamed:@"RCTJMessageBundle.bundle/transactionMessage"];
    }else if (self.indexPath.row==1)
    {
        _NameLabel.text=@"客户预约";
        _iconImage.image=[UIImage imageNamed:@"RCTJMessageBundle.bundle/reserveMessage"];
    }else{
        _NameLabel.text=@"互动消息";
        _iconImage.image=[UIImage imageNamed:@"RCTJMessageBundle.bundle/projectMessage"];
    }
}
-(void)setcellView
{
   
    UIView *backImg=[[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_Width, 69)];
    backImg.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:backImg];
    _iconImage=[[UIImageView alloc]init];
    [backImg addSubview:_iconImage];
    [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10];
    [_iconImage autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [_iconImage autoSetDimensionsToSize:CGSizeMake(50, 50)];
    _unReadNumbelLabel=[[UIButton alloc]init];
    [backImg addSubview:_unReadNumbelLabel];
    _unReadNumbelLabel.backgroundColor=[UIColor colorWithHexString:@"0xff0000"];
    [_unReadNumbelLabel setTintColor:[UIColor colorWithHexString:@"0xffffff"]];
    _unReadNumbelLabel.titleLabel.font=[UIFont systemFontOfSize:12];
    [_unReadNumbelLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:6];
    [_unReadNumbelLabel.titleLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    _NameLabel=[[UILabel alloc]init];
    [backImg addSubview:_NameLabel];
    [_NameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:10];
    [_NameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:19];
    _NameLabel.textColor=[UIColor colorWithHexString:@"0x444444"];
    _NameLabel.font=[UIFont systemFontOfSize:14];
    _MessageLabel=[[UILabel alloc]init];
    [backImg addSubview:_MessageLabel];
    [_MessageLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_NameLabel withOffset:5];
    [_MessageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:_iconImage withOffset:10];
    [_MessageLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:150];
    _MessageLabel.textColor=[UIColor colorWithHexString:@"0x9b9b9b"];
    _MessageLabel.font=[UIFont systemFontOfSize:12];
    _timeLabel=[[UILabel alloc]init];
    [backImg addSubview:_timeLabel];
    _timeLabel.textColor=[UIColor colorWithHexString:@"0x6a7180"];
    _timeLabel.font=[UIFont systemFontOfSize:12];
    [_timeLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:25];
    [_timeLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:25];
    UIImageView *jiantouView=[[UIImageView alloc]init];
    [backImg addSubview:jiantouView];
    [jiantouView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10];
    [jiantouView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:30];
    [jiantouView autoSetDimensionsToSize:CGSizeMake(6, 10)];
    jiantouView.image=[UIImage imageNamed:@"RCTJMessageBundle.bundle/rightCopy"];

}
@end
