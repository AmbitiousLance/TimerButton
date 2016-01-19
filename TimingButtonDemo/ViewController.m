//
//  ViewController.m
//  TimingButtonDemo
//
//  Created by Lance Wu on 16/1/19.
//  Copyright © 2016年 Lance Wu. All rights reserved.
//

#import "ViewController.h"
#import "TimerButton.h"

@interface ViewController ()<TimingDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    TimerButton *blockBtn = [[TimerButton alloc] initWithFrame:CGRectMake(100, 100, 150, 30) title:@"获取验证码" seconds:60 progressBlock:^(TimerButton *button, TimeState state, NSString *restTime) {
        switch (state) {
            case TimeDuration:{
                //进行中
                [button setTitle:[NSString stringWithFormat:@"重新获取(%@s)",restTime] forState:UIControlStateNormal];
            }
                break;
            case TimeFinish:{
                //结束
                [button setTitle:@"重新获取" forState:UIControlStateNormal];
            }
            default:{
                //开始
                NSLog(@"计时开始");
            }
                break;
        }
    }];
    [blockBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [blockBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.view addSubview:blockBtn];
    
    
    TimerButton *delegateBtn = [[TimerButton alloc] initWithFrame:CGRectMake(100, 200, 150, 30) title:@"获取验证码" seconds:60 delegate:self];
    [delegateBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [delegateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.view addSubview:delegateBtn];
}

#pragma mark - TimingDelegate
- (void)startRunning:(TimerButton *)button state:(TimeState)state restTime:(NSString *)restTime{
    switch (state) {
        case TimeDuration:{
            //进行中
            [button setTitle:[NSString stringWithFormat:@"重新获取(%@s)",restTime] forState:UIControlStateNormal];
        }
            break;
        case TimeFinish:{
            //结束
            [button setTitle:@"重新获取" forState:UIControlStateNormal];
        }
        default:{
            //开始
            NSLog(@"计时开始");
        }
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
