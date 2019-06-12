//
//  AlumChooseController.h
//  VChatApp
//
//  Created by LewisC on 2019/2/21.
//  Copyright © 2019年 Super. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AlumselectDelegate <NSObject>

- (void)didSelectPhoto:(UIImage*)image;

@end
@interface JiaRenMiYu_AlumChooseController : UIViewController

@property(nonatomic, weak)id<AlumselectDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
