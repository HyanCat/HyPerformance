//
//  HyPerformanceView.m
//
//  Created by HyanCat on 10/02/2017.
//
//

#import "HyPerformanceView.h"
#import "HyProgressView.h"
#import "HyTipView.h"
#import "HyCPUMonitor.h"
#import "HyFPSMonitor.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ViewRect CGRectMake(0, 0, ScreenWidth, 2.f)

NS_INLINE void delay(NSTimeInterval second, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

@interface HyPerformanceView ()

@property (nonatomic, weak) UIWindow *window;
@property (nonatomic, strong) HyProgressView *fpsProgressView;
@property (nonatomic, strong) HyProgressView *cpuProgressView;

@property (nonatomic, strong) CADisplayLink *displayLink;

@end

static UIWindow *performanceWindow;

@implementation HyPerformanceView

+ (void)show
{
    UIWindow *window = [[UIWindow alloc] initWithFrame:ViewRect];
    window.windowLevel = UIWindowLevelStatusBar + 1;
    [self showInWindow:window];
    performanceWindow = window;

    delay(0.1f, ^{
        [window makeKeyAndVisible];
    });
}

+ (void)showInWindow:(UIWindow *)window
{
    HyPerformanceView *view = [[HyPerformanceView alloc] initWithFrame:ViewRect];
    view.window = window;
    view.backgroundColor = [UIColor clearColor];
    [window addSubview:view];

    [view _makeFPSProgress];
    [view _makeCPUProgress];
}

- (void)_makeFPSProgress
{
    HyProgressView *fpsProgressView = [[HyProgressView alloc] initWithFrame:self.bounds];
    [self addSubview:fpsProgressView];
    self.fpsProgressView = fpsProgressView;

    [HyFPSMonitor fpsMonitoring:^(float fps) {
        [self.fpsProgressView setProgress:fps/60.f animated:YES];
    }];
}

- (void)_makeCPUProgress
{
    HyProgressView *cpuProgressView = [[HyProgressView alloc] initWithFrame:self.bounds];
    [self addSubview:cpuProgressView];
    self.cpuProgressView = cpuProgressView;

    [HyCPUMonitor cpuMonitoring:^(float cpu) {
        [self.cpuProgressView setProgress:cpu/100.f animated:YES];
    }];
}

+ (void)hide
{
    [UIApplication sharedApplication];
}

@end
