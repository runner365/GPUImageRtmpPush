//
//  BeautyRtmpPushViewController.h
//  GPUImageRtmpPush
//
//  Created by 施维 on 16/7/12.
//  Copyright © 2016年 xiaoq. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, FILTER_TYPE) {
    FILTER_BEAUTY_TYPE = 0,
    FILTER_SEPIA_TYPE = 1,
    FILTER_SKETCH_TYPE = 2,
    FILTER_BRIGHT_TYPE = 3,
    FILTER_BRIGHT_BEAUTY_TYPE = 4
};

@interface MutipleFilterRtmpPushViewController : UIViewController

@property (nonatomic, strong) NSString* rtmpUrlString;

@property (nonatomic, assign) FILTER_TYPE filterType;

@end
