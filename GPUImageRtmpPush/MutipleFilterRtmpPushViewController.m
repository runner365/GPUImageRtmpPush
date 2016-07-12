//
//  BeautyRtmpPushViewController.m
//  GPUImageRtmpPush
//
//  Created by 施维 on 16/7/12.
//  Copyright © 2016年 xiaoq. All rights reserved.
//

#import "MutipleFilterRtmpPushViewController.h"
#import "GPUImage.h"
#import "GPUImageSketchFilter.h"
#import "GPUImageBeautifyFilter.h"
#import "GPUImageSepiaFilter.h"
#import "GPUImageBrightnessFilter.h"

#import "GPUImageMovieWriterEx.h"
#import "../RtmpLivePushSDK/VideoCore/api/IOS/VCRtmpSession.h"

@interface MutipleFilterRtmpPushViewController ()<PixelBufferDelegate>

@property (nonatomic, strong) UIView* liveBKView;
@property (nonatomic, strong) UIButton* closeButton;

@property (atomic, strong) GPUImageVideoCamera *videoCamera;
@property (atomic, strong) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic, strong) GPUImageView *filterView;
@property (nonatomic, strong) GPUImageMovieWriterEx *movieWriter;

@property (nonatomic, strong) VCRtmpSession* rtmpSession;

@end

@implementation MutipleFilterRtmpPushViewController

-(void)UIInit{
    self.liveBKView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WEIGHT, SCREEN_HEIGHT)];
    self.liveBKView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:self.liveBKView];
    
    self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT-10-70, SCREEN_HEIGHT-10-30, 70, 30)];
    self.closeButton.backgroundColor = [UIColor grayColor];
    [self.closeButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.closeButton setTitle:@"退出" forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(OnCloseClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.closeButton];
}

-(void)RtmpPushInit{
    self.rtmpSession = [[VCRtmpSession alloc] initWithVideoSize:VIDEO_SIZE_CIF fps:25 bitrate:BITRATE_CIF];
    [self.rtmpSession startRtmpSession:@"rtmp://192.168.1.104/live/123456"];
    
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
    self.videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionFront];
    self.videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.videoCamera.horizontallyMirrorFrontFacingCamera = NO;
    self.videoCamera.horizontallyMirrorRearFacingCamera = NO;
    
    AVCaptureSession* session = self.videoCamera.captureSession;
    AVCaptureVideoPreviewLayer* previewLayer;
    previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    previewLayer.frame = [UIScreen mainScreen].bounds;
    
    switch(self.filterType){
        case FILTER_BEAUTY_TYPE:
            self.filter = [[GPUImageBeautifyFilter alloc] init];
            [self.videoCamera addTarget:self.filter];
            break;
        case FILTER_SEPIA_TYPE:
            self.filter = [[GPUImageSepiaFilter alloc] init];
            [self.videoCamera addTarget:self.filter];
            break;
        case FILTER_SKETCH_TYPE:
            self.filter = [[GPUImageSketchFilter alloc] init];
            [self.videoCamera addTarget:self.filter];
            break;
        case FILTER_BRIGHT_TYPE:{
            GPUImageBrightnessFilter* brightFilter = [[GPUImageBrightnessFilter alloc] init];
            brightFilter.brightness = 0.2;
            self.filter = brightFilter;
            [self.videoCamera addTarget:self.filter];
            break;
        }
        case FILTER_BRIGHT_BEAUTY_TYPE:{
            GPUImageBrightnessFilter* brightFilter = [[GPUImageBrightnessFilter alloc] init];
            brightFilter.brightness = 0.17;
            GPUImageBeautifyFilter* beautyFilter = [[GPUImageBeautifyFilter alloc] init];
            [brightFilter addTarget:beautyFilter];
            self.filter = beautyFilter;
            [self.videoCamera addTarget:brightFilter];
            break;
        }
    }
    
    self.filterView = [[GPUImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    self.filterView.backgroundColor = [UIColor lightGrayColor];
    [self.liveBKView addSubview:self.filterView];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    self.movieWriter = [[GPUImageMovieWriterEx alloc] initWithMovieURL:movieURL size:CGSizeMake(360.0, 640.0)];
    self.movieWriter.encodingLiveVideo = YES;
    self.movieWriter.pixelBufferdelegate = self;
    [self.filter addTarget:self.movieWriter];
    
    [self.filter addTarget:self.filterView];
    
    [self.videoCamera startCameraCapture];
    
    [self.movieWriter startRecording];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UIInit];
    
    [self RtmpPushInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)OnCloseClicked:(id)sender{
    [self.movieWriter cancelRecording];
    [self.videoCamera stopCameraCapture];
    
    [[GPUImageContext sharedFramebufferCache] purgeAllUnassignedFramebuffers];
    
    [self.filter removeTarget:self.movieWriter];
    [self.filter removeTarget:self.filterView];
    [self.filter removeOutputFramebuffer];
    
    [self.videoCamera removeTarget:self.filter];
    
    
    
    [self.rtmpSession endRtmpSession];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark-
#pragma mark--视频数据处理回调
-(void)PixelBufferCallback:(CVPixelBufferRef)pixelFrameBuffer{
//    unsigned long ulLen = CVPixelBufferGetDataSize(pixelFrameBuffer);
//    unsigned long iWidth = CVPixelBufferGetWidth(pixelFrameBuffer);
//    unsigned long iHeight = CVPixelBufferGetHeight(pixelFrameBuffer);
//    int iFormatType = CVPixelBufferGetPixelFormatType(pixelFrameBuffer);
//    NSLog(@"PixelBufferCallback: %lu X %lu, formattype=%d, ulLen=%lu", iWidth, iHeight, iFormatType, ulLen);
    
    if(self.rtmpSession){
        [self.rtmpSession PutBuffer:pixelFrameBuffer];
    }
}
@end
