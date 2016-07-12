//
//  ViewController.m
//  GPUImageRtmpPush
//
//  Created by 施维 on 16/7/12.
//  Copyright © 2016年 xiaoq. All rights reserved.
//

#import "ViewController.h"
#import "MutipleFilterRtmpPushViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UITextField* rtmpUrlTextField;
@property (nonatomic, strong) UIButton* beautyRtmpPushButton;
@property (nonatomic, strong) UIButton* sepiaRtmpPushButton;
@property (nonatomic, strong) UIButton* sketchRtmpPushButton;
@property (nonatomic, strong) UIButton* brightRtmpPushButton;
@property (nonatomic, strong) UIButton* brightbeautyRtmpPushButton;

@end

@implementation ViewController

-(void)UIInit{
    self.rtmpUrlTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 70, SCREEN_WEIGHT-15*2, 30)];
    self.rtmpUrlTextField.backgroundColor = [UIColor grayColor];
    self.rtmpUrlTextField.text = @"rtmp://192.168.1.104/live/123456";
    self.rtmpUrlTextField.textColor = [UIColor whiteColor];
    [self.view addSubview:self.rtmpUrlTextField];
    
    double fbeautyRtmpPushButtonY = 70+30+20;
    self.beautyRtmpPushButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/2-100/2, fbeautyRtmpPushButtonY, 100, 30)];
    self.beautyRtmpPushButton.backgroundColor = [UIColor grayColor];
    [self.beautyRtmpPushButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.beautyRtmpPushButton setTitle:@"美颜滤镜直播" forState:UIControlStateNormal];
    [self.beautyRtmpPushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.beautyRtmpPushButton addTarget:self action:@selector(OnBeautyPushClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.beautyRtmpPushButton.tag = 100;
    [self.view addSubview:self.beautyRtmpPushButton];
    
    double fsepiaRtmpPushButtonY = fbeautyRtmpPushButtonY + 30 + 10;
    self.sepiaRtmpPushButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/2-100/2, fsepiaRtmpPushButtonY, 100, 30)];
    self.sepiaRtmpPushButton.backgroundColor = [UIColor grayColor];
    [self.sepiaRtmpPushButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.sepiaRtmpPushButton setTitle:@"复古滤镜直播" forState:UIControlStateNormal];
    [self.sepiaRtmpPushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sepiaRtmpPushButton addTarget:self action:@selector(OnBeautyPushClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.sepiaRtmpPushButton.tag = 101;
    [self.view addSubview:self.sepiaRtmpPushButton];
    
    double fsketchRtmpPushButtonY = fsepiaRtmpPushButtonY + 30 + 10;
    self.sketchRtmpPushButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/2-100/2, fsketchRtmpPushButtonY, 100, 30)];
    self.sketchRtmpPushButton.backgroundColor = [UIColor grayColor];
    [self.sketchRtmpPushButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.sketchRtmpPushButton setTitle:@"素描滤镜直播" forState:UIControlStateNormal];
    [self.sketchRtmpPushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.sketchRtmpPushButton addTarget:self action:@selector(OnBeautyPushClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.sketchRtmpPushButton.tag = 102;
    [self.view addSubview:self.sketchRtmpPushButton];
    
    double fbrightRtmpPushButtonY = fsketchRtmpPushButtonY + 30 + 10;
    self.brightRtmpPushButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/2-100/2, fbrightRtmpPushButtonY, 100, 30)];
    self.brightRtmpPushButton.backgroundColor = [UIColor grayColor];
    [self.brightRtmpPushButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [self.brightRtmpPushButton setTitle:@"高亮滤镜直播" forState:UIControlStateNormal];
    [self.brightRtmpPushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.brightRtmpPushButton addTarget:self action:@selector(OnBeautyPushClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.brightRtmpPushButton.tag = 103;
    [self.view addSubview:self.brightRtmpPushButton];
    
    double fbrightbeautyRtmpPushButtonY = fbrightRtmpPushButtonY + 30 + 10;
    self.brightbeautyRtmpPushButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WEIGHT/2-100/2, fbrightbeautyRtmpPushButtonY, 100, 30)];
    self.brightbeautyRtmpPushButton.backgroundColor = [UIColor grayColor];
    [self.brightbeautyRtmpPushButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
    [self.brightbeautyRtmpPushButton setTitle:@"高亮+美颜滤镜直播" forState:UIControlStateNormal];
    [self.brightbeautyRtmpPushButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.brightbeautyRtmpPushButton addTarget:self action:@selector(OnBeautyPushClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.brightbeautyRtmpPushButton.tag = 104;
    [self.view addSubview:self.brightbeautyRtmpPushButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self UIInit];
}

-(void)OnBeautyPushClicked:(UIButton*)sender{
    MutipleFilterRtmpPushViewController* RtmpPushVC = [[MutipleFilterRtmpPushViewController alloc] init];
    
    RtmpPushVC.rtmpUrlString = self.rtmpUrlTextField.text;
    switch(sender.tag){
        case 100:
            RtmpPushVC.filterType    = FILTER_BEAUTY_TYPE;
            break;
        case 101:
            RtmpPushVC.filterType    = FILTER_SEPIA_TYPE;
            break;
        case 102:
            RtmpPushVC.filterType    = FILTER_SKETCH_TYPE;
            break;
        case 103:
            RtmpPushVC.filterType    = FILTER_BRIGHT_TYPE;
            break;
        case 104:
            RtmpPushVC.filterType    = FILTER_BRIGHT_BEAUTY_TYPE;
            break;
    }
    
    [self presentViewController:RtmpPushVC animated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
