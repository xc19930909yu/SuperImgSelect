//
//  SelectImgtypeModel.h
//  BangMall
//
//  Created by 徐超 on 2019/5/19.
//  Copyright © 2019年 ygj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectImgtypeModel : NSObject

/// 获取的缩略图
@property(nonatomic, strong)UIImage *img;

@property(nonatomic, copy)NSString *name;

@property(nonatomic, copy)NSString *number;

@property(nonatomic, strong)PHFetchResult<PHAsset *> *assetsFetchResult;

@end

NS_ASSUME_NONNULL_END
