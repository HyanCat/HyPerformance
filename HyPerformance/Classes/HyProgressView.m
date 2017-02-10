//
//  HyProgressView.m
//  Pods
//
//  Created by NyanCat on 10/02/2017.
//
//

#import "HyProgressView.h"

@interface HyProgressView ()

@property (nonatomic, copy) HyProgressColorFuction colorFunction;
@end

@implementation HyProgressView
@synthesize progress = _progress;

- (void)setProgress:(float)progress
{
    if (_progress == progress) return;
    _progress = progress;

    self.progressTintColor = self.colorFunction ? self.colorFunction(progress) : [self progressColor:self.progress];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    if (_progress == progress) return;
    _progress = progress;

    self.progressTintColor = self.colorFunction ? self.colorFunction(progress) : [self progressColor:self.progress];

    [super setProgress:progress animated:animated];
}

- (UIColor *)progressColor:(float)progress
{
    CGFloat hue = progress > 0.4f ? (progress - 0.4f) / 2 : 0;
    return [UIColor colorWithHue:hue saturation:1 brightness:0.9 alpha:1];
}

@end
