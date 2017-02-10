//
//  HyCPUMonitor.m
//
//  Created by HyanCat on 10/02/2017.
//
//

#import "HyCPUMonitor.h"
#import <mach/mach.h>

float hy_cpu_usage();

@interface HyCPUMonitor ()
{
    dispatch_source_t _timer;
    NSTimeInterval _interval;
}

@end

@implementation HyCPUMonitor

+ (instancetype)sharedMonitor
{
    static HyCPUMonitor *monitor;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[HyCPUMonitor alloc] init];
        monitor->_interval = 0.5;
    });
    return monitor;
}

+ (void)refreshInteval:(NSTimeInterval)interval
{
    [HyCPUMonitor sharedMonitor]->_interval = interval;
}

+ (void)cpuMonitoring:(CPUMonitoringBlock)block
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, [HyCPUMonitor sharedMonitor]->_interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        float usage = hy_cpu_usage();
        NSLog(@"cpu usage: %f", usage);
        if (block) {
            block(usage);
        }
    });
    dispatch_resume(timer);

    [HyCPUMonitor sharedMonitor]->_timer = timer;
}

+ (void)halt
{
    dispatch_source_t timer = [HyCPUMonitor sharedMonitor]->_timer;
    if (timer) {
        dispatch_source_cancel(timer);
        timer = nil;
    }
}

@end

typedef mach_msg_type_number_t COUNT;

float hy_cpu_usage()
{
    /**
     * We get the cpu usage through the mach kern functions.
     * @see https://www.gnu.org/software/hurd/gnumach-doc/Task-Information.html
     */

    task_name_t taskSelf = mach_task_self();

    // Get current task info.
    task_info_data_t taskInfo;
    COUNT taskInfoCount = TASK_INFO_MAX;
    {
        kern_return_t kr = task_info(taskSelf, TASK_BASIC_INFO, taskInfo, &taskInfoCount);
        if (kr != KERN_SUCCESS) {
            return 0;
        }
    }

    // Get threads info.
    thread_array_t threads;
    COUNT threadCount;
    {
        kern_return_t kr = task_threads(taskSelf, &threads, &threadCount);
        if (kr != KERN_SUCCESS) {
            return 0;
        }
    }

    // Calculate the sum of each thread's cpu usage.
    float usage = 0.f;
    for (NSUInteger i = 0; i < threadCount; i++) {
        thread_info_data_t threadInfo;
        COUNT threadInfoCount;
        kern_return_t kr = thread_info(threads[i], THREAD_BASIC_INFO, threadInfo, &threadInfoCount);
        if (kr != KERN_SUCCESS) {
            continue;
        }
        usage += ((float)((thread_basic_info_t)threadInfo)->cpu_usage) / TH_USAGE_SCALE;
    }

    // Free threads' memories.
    kern_return_t kr = vm_deallocate(taskSelf, (vm_offset_t)threads, threadCount*sizeof(thread_t));
    assert(kr == KERN_SUCCESS);

    return usage;
}
