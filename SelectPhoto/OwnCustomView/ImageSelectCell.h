//
//  ImageSelectCell.h
//  BangMall
//
//  Created by 徐超 on 2019/5/19.
//  Copyright © 2019年 ygj. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectImgtypeModel;
NS_ASSUME_NONNULL_BEGIN

@interface ImageSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *firstIcon;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;


@property (nonatomic, strong)SelectImgtypeModel *selectModel;

@end

NS_ASSUME_NONNULL_END
