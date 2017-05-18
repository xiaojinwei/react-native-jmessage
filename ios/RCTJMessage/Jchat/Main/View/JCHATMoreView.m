//
//  JPIMMore.m
//  JPush IM
//
//  Created by Apple on 14/12/30.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import "JCHATMoreView.h"
#import "JChatConstants.h"
#import "ViewUtil.h"
@implementation JCHATMoreView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)drawRect:(CGRect)rect {
  
}

- (IBAction)photoBtnClick:(id)sender {
  
  if (self.delegate &&[self.delegate respondsToSelector:@selector(photoClick)]) {
    [self.delegate photoClick];
  }
}
- (IBAction)cameraBtnClick:(id)sender {
  if (self.delegate &&[self.delegate respondsToSelector:@selector(cameraClick)]) {
    [self.delegate cameraClick];
  }
}
@end


@implementation JCHATMoreViewContainer

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
  }
  return self;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  _moreView = NIB(JCHATMoreView);
  
  _moreView.frame =CGRectMake(0, 0, 320, 100);
    [_moreView.photoBtn setImage:[UIImage imageNamed:@"RCTJMessageBundle.bundle/photo_24.png"] forState:UIControlStateNormal];
    [_moreView.cameraBtn setImage:[UIImage imageNamed:@"RCTJMessageBundle.bundle/camera_35.png"] forState:UIControlStateNormal];
    _moreView.backgroundColor=UIColorFromRGB(0xffffff);
  //  [_toolbar drawRect:_toolbar.frame];
  
  //  _toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  [self addSubview:_moreView];
}

@end

