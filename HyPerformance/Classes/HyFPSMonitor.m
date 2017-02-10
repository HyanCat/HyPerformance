//
//  HyFPSMonitor.m
//
//  Created by HyanCat on 10/02/2017.
//
//

#import "HyFPSMonitor.h"
#import "HyCADisplayLinkDelegate.h"

@interface HyFPSMonitor ()
{
    HyCADisplayLinkDelegate *_displayLinkDelegate;
}

@end

@implementation HyFPSMonitor

+ (instancetype)sharedMonitor
{
    static HyFPSMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[HyFPSMonitor alloc] init];
    });
    return monitor;
}

+ (void)fpsMonitoring:(FPSMonitoringBlock)block
{
    __block CFTimeInterval lastTime = 0;
    __block NSUInteger displayRefreshCount = 0;
    HyCADisplayLinkDelegate *displayLinkDelegate = [HyCADisplayLinkDelegate displayLinkWithEventHandler:^(CADisplayLink *displayLink) {
        CFTimeInterval currentTime = displayLink.timestamp;
        if (lastTime == 0) {
            // first time.
            lastTime = currentTime;
            return;
        }
        displayRefreshCount++;
        CFTimeInterval deltaTime = currentTime - lastTime;
        if (deltaTime < 1.0)
            return;
        // After 1 second.
        float fps = MIN(lrint(displayRefreshCount / deltaTime), 60);
        displayRefreshCount = 0;
        lastTime = currentTime;

        if (block) {
            NSLog(@"fps: %f", fps);
            block(fps);
        }
    }];

    [HyFPSMonitor sharedMonitor]->_displayLinkDelegate = displayLinkDelegate;
}

+ (void)halt
{
    [[HyFPSMonitor sharedMonitor]->_displayLinkDelegate.displayLink invalidate];
    [HyFPSMonitor sharedMonitor]->_displayLinkDelegate = nil;
}

@end
