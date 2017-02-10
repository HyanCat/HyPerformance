//
//  HyCADisplayLinkDelegate.m
//  Pods
//
//  Created by NyanCat on 10/02/2017.
//
//

#import "HyCADisplayLinkDelegate.h"

@interface HyCADisplayLinkDelegate ()

@property (nonatomic, copy) HyDisplayLinkEvent event;

@end

@implementation HyCADisplayLinkDelegate

+ (instancetype)displayLinkWithEventHandler:(HyDisplayLinkEvent)event
{
    HyCADisplayLinkDelegate *delegate = [[HyCADisplayLinkDelegate alloc] init];

    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:delegate selector:@selector(eventHandler)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    delegate.displayLink = displayLink;
    delegate.event = event;
    return delegate;
}

- (void)eventHandler
{
    if (self.event) {
        self.event(self.displayLink);
    }
}

@end
