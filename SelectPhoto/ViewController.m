//
//  ViewController.m
//  SelectPhoto
//
//  Created by 李朋朋 on 2019/6/12.
//  Copyright © 2019 李朋朋. All rights reserved.
//

#import "ViewController.h"
#import "JiaRenMiYu_AlumChooseController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    JiaRenMiYu_AlumChooseController  *vc = [[JiaRenMiYu_AlumChooseController alloc]  init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
