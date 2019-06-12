//
//  AlumViewCell.m
//  VChatApp
//
//  Created by LewisC on 2019/2/21.
//  Copyright © 2019年 Super. All rights reserved.
//

#import "JiaRenMiYu_AlumViewCell.h"
#import "Masonry.h"

@implementation JiaRenMiYu_AlumViewCell


- (UIImageView *)JiaRenMiYuBLM_takeImg{
    if (!_JiaRenMiYuBLM_takeImg) {
        _JiaRenMiYuBLM_takeImg = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:@"xiangji"]];
    }
    
    return _JiaRenMiYuBLM_takeImg;
}

- (UIImageView *)JiaRenMiYuBLM_backImg{
    if (!_JiaRenMiYuBLM_backImg) {
        _JiaRenMiYuBLM_backImg = [[UIImageView alloc]  init];
    }
    return _JiaRenMiYuBLM_backImg;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self JiaRenMiYuFFM_addView];
    }
    return self;
}


- (void)JiaRenMiYuFFM_addView{
    self.backgroundColor = [UIColor whiteColor]; //kRGB_alpha(38, 38, 38, 1.0); //RGB(38, 38, 38, 1.0);
    [self addSubview:self.JiaRenMiYuBLM_takeImg];
    [self addSubview:self.JiaRenMiYuBLM_backImg];
    [self JiaRenMiYuFFM_snapView];
}


- (void)JiaRenMiYuFFM_snapView{
    [self.JiaRenMiYuBLM_takeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(64, 64));
    }];
    
    [self.JiaRenMiYuBLM_backImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(1);
        make.right.bottom.equalTo(self).offset(-1);
    }];
    
}

@end
