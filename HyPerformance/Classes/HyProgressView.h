//
//  HyProgressView.h
//  Pods
//
//  Created by NyanCat on 10/02/2017.
//
//

#import <UIKit/UIKit.h>

typedef UIColor*(^HyProgressColorFuction)(float progress);

@interface HyProgressView : UIProgressView

- (void)progressColorFuction:(HyProgressColorFuction)function;

@end
