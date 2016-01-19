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
{
    __weak IBOutlet TimerButton *_storyboardBtn;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [_storyboardBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    _storyboardBtn.tag = 100;
    [_storyboardBtn startWithSeconds:60 delegate:self];
    
    
    TimerButton *blockBtn = [[TimerButton alloc] initWithFrame:CGRectMake(100, 100, 150, 30) title:@"获取验证码" durationTitle:@"重新获取" seconds:60 progressBlock:^(TimerButton *button, TimeState state, NSString *restTime) {
        if (state == TimeStart) {
            NSLog(@"计时开始");
        }
    }];
    [blockBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [blockBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.view addSubview:blockBtn];
    
    
    TimerButton *delegateBtn = [[TimerButton alloc] initWithFrame:CGRectMake(100, 200, 150, 30) title:@"获取验证码" durationTitle:@"重新获取" seconds:60 delegate:self];
    [delegateBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [delegateBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [self.view addSubview:delegateBtn];
}

#pragma mark - TimingDelegate
- (void)startRunningByButton:(TimerButton *)button state:(TimeState)state restTime:(NSString *)restTime{
    if (state == TimeStart) {
        NSLog(@"计时开始");
    }else{
        if (button.tag == 100) {
            if (state == TimeDuration) {
                [button setTitle:[NSString stringWithFormat:@"重新发送(%@s)",restTime] forState:UIControlStateNormal];
            }else{
                [button setTitle:@"重新发送" forState:UIControlStateNormal];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
