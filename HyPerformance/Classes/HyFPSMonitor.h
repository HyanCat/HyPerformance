//
//  HyFPSMonitor.h
//
//  Created by HyanCat on 10/02/2017.
//
//

#import <Foundation/Foundation.h>

typedef void(^FPSMonitoringBlock)(float fps);

@interface HyFPSMonitor : NSObject

+ (void)fpsMonitoring:(FPSMonitoringBlock)block;

+ (void)halt;

@end
