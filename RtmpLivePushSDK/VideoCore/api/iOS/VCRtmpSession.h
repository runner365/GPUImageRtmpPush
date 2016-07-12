//
//  VCRtmpSession.h
//  RtmpLivePushSDK
//
//  Created by 施维 on 16/6/14.
//  Copyright © 2016年 com.Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#define AUDIO_DEF_SAMPLERATE 22050
#define AUDIO_DEF_CHANNELNUM 2
#define AUDIO_DEF_BITRATE    64000

#define VIDEO_SIZE_CIF CGSizeMake(360, 640) //推荐600kbps， 25帧
#define VIDEO_SIZE_D1  CGSizeMake(540, 960) //推荐800kbps, 25帧
//不推荐手机做720P直播，WIFI信号不稳定，会导致上行速率波动，效果不好

#define BITRATE_CIF (600*1000)
#define BITRATE_D1  (800*1000)

@interface VCRtmpSession : NSObject

/*! Setters / Getters for session properties */
@property (nonatomic, assign) CGSize            videoSize;      // Change will not take place until the next RTMP Session
@property (nonatomic, assign) int               bitrate;        // Change will not take place until the next RTMP Session
@property (nonatomic, assign) int               fps;            // Change will not take place until the next RTMP

-(VCRtmpSession*)initWithVideoSize:(CGSize)videoSize
                               fps:(CGFloat)fFps
                           bitrate:(CGFloat)fBitRate;

- (void) startRtmpSession:(NSString *)rtmpUrl;

- (void) endRtmpSession;

-(void)PutBuffer:(CVPixelBufferRef)pixelBuff;

@end
