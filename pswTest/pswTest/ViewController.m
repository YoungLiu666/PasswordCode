//
//  ViewController.m
//  pswTest
//
//  Created by hero on 2019/9/23.
//  Copyright © 2019年 Hero. All rights reserved.
//

#import "ViewController.h"
#import "JZView.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet JZView *passwordView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lock_pad_bg"]];
    NSString *str = @"012";
    self.passwordView.passWordBlock = ^BOOL(NSString *password) {
        if ([str isEqualToString:password]) {
            NSLog(@"密码正确");
            return YES;
        }else{
            NSLog(@"密码错误");
            return NO;
        };
    };
}


@end
