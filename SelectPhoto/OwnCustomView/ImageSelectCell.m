//
//  ImageSelectCell.m
//  BangMall
//
//  Created by 徐超 on 2019/5/19.
//  Copyright © 2019年 ygj. All rights reserved.
//

#import "ImageSelectCell.h"
#import "SelectImgtypeModel.h"

@implementation ImageSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setSelectModel:(SelectImgtypeModel *)selectModel{
    _selectModel = selectModel;
    self.firstIcon.image = selectModel.img;
    self.typeLabel.text = selectModel.name;
    self.numberLabel.text = selectModel.number;
}

@end
