//
//  HyCPUMonitor.h
//
//  Created by HyanCat on 10/02/2017.
//
//

#import <Foundation/Foundation.h>

typedef void(^CPUMonitoringBlock)(float cpu);

@interface HyCPUMonitor : NSObject

+ (void)refreshInteval:(NSTimeInterval)interval;

+ (void)cpuMonitoring:(CPUMonitoringBlock)block;

+ (void)halt;

@end
