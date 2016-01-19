//
//  TimerButton.h
//  KidApp
//
//  Created by Lance Wu on 16/1/18.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimerButton;

// An enumeration which can tell you the button state in real time.
typedef NS_ENUM(NSUInteger, TimeState){
    TimeStart = 0,
    TimeDuration,
    TimeFinish
};

typedef void (^progressBlock)(TimerButton *button, TimeState state, NSString *restTime);

@protocol TimingDelegate <NSObject>

@optional
/**
 * @param button      present button
 * @param state         present state
 */
- (void)startRunningByButton:(TimerButton *)button state:(TimeState)state restTime:(NSString *)restTime;

@end

@interface TimerButton : UIButton

@property (nonatomic, strong) progressBlock progressBlock;
@property (nonatomic, strong) id<TimingDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title durationTitle:(NSString *)durationTitle seconds:(NSInteger)seconds progressBlock:(progressBlock)progressBlock;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title durationTitle:(NSString *)durationTitle seconds:(NSInteger)seconds delegate:(id<TimingDelegate>)delegate;

// When you use storyboard or xib, you have to use these methods to realize the function.
// Warning: You have to select the custom type of the button if the button is in the storyboard or xib, or the title will shine every second.

- (void)startWithSeconds:(NSInteger)seconds delegate:(id<TimingDelegate>)delegate;
- (void)startWithSeconds:(NSInteger)seconds progressBlock:(progressBlock)progressBlock;

@end
