//
//  HyCADisplayLinkDelegate.h
//  Pods
//
//  Created by NyanCat on 10/02/2017.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^HyDisplayLinkEvent)(CADisplayLink *);

@interface HyCADisplayLinkDelegate : NSObject

@property (nonatomic, weak) CADisplayLink *displayLink;

+ (instancetype)displayLinkWithEventHandler:(void (^)(CADisplayLink *))event;

@end

NS_ASSUME_NONNULL_END
