//
//  TimerButton.m
//  KidApp
//
//  Created by Lance Wu on 16/1/18.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import "TimerButton.h"

@interface TimerButton ()
@property (nonatomic, assign) NSInteger seconds;
@property (nonatomic, strong) NSString *durationTitle;
@end

@implementation TimerButton

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title durationTitle:(NSString *)durationTitle seconds:(NSInteger)seconds progressBlock:(progressBlock)progressBlock{
    if (self = [super initWithFrame:frame]) {
        _durationTitle = durationTitle;
        [self setTitle:title forState:UIControlStateNormal];
        [self addTargetActionWithSeconds:seconds delegate:nil progressBlock:progressBlock];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title durationTitle:(NSString *)durationTitle seconds:(NSInteger)seconds delegate:(id<TimingDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        _durationTitle = durationTitle;
        [self setTitle:title forState:UIControlStateNormal];
        [self addTargetActionWithSeconds:seconds delegate:delegate progressBlock:nil];
   }
    return self;
}

- (void)startWithSeconds:(NSInteger)seconds delegate:(id<TimingDelegate>)delegate{
    [self addTargetActionWithSeconds:seconds delegate:delegate progressBlock:nil];
}

- (void)startWithSeconds:(NSInteger)seconds progressBlock:(progressBlock)progressBlock{
    [self addTargetActionWithSeconds:seconds delegate:nil progressBlock:progressBlock];
}

- (void)addTargetActionWithSeconds:(NSInteger)seconds delegate:(id<TimingDelegate>)delegate progressBlock:(progressBlock)progressBlock{
    _seconds = seconds;
    _delegate = delegate;
    _progressBlock = progressBlock;
    [self addTarget:self action:@selector(startCountDown) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - CountDown
- (void)startCountDown{
    //timeStart
    if (_delegate && [_delegate respondsToSelector:@selector(startRunningByButton:state:restTime:)]) {
        [_delegate startRunningByButton:self state:TimeStart restTime:nil];
    }
    if (_progressBlock) {
        _progressBlock(self,TimeStart,nil);
    }

    __block NSInteger timeout = _seconds-1; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = YES;
                if (_durationTitle) {
                    [self setTitle:_durationTitle forState:UIControlStateNormal];
                }
                //timeFinish
                if (_delegate && [_delegate respondsToSelector:@selector(startRunningByButton:state:restTime:)]) {
                    [_delegate startRunningByButton:self state:TimeFinish restTime:nil];
                }
                if (_progressBlock) {
                    _progressBlock(self,TimeFinish,nil);
                }

            });
        }else{
            NSInteger seconds = timeout % _seconds;
            NSString *restTime = [NSString stringWithFormat:@"%.2ld", (long)seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enabled = NO;
                if (_durationTitle) {
                    [self setTitle:[NSString stringWithFormat:@"%@(%@s)",_durationTitle,restTime] forState:UIControlStateNormal];
                }
                //timeDuration
                if (_delegate && [_delegate respondsToSelector:@selector(startRunningByButton:state:restTime:)]) {
                    [_delegate startRunningByButton:self state:TimeDuration restTime:restTime];
                }
                if (_progressBlock) {
                    _progressBlock(self,TimeDuration,restTime);
                }
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);

}

@end
