# GPUImageRtmpPush
iOS rtmp推流sdk，可以接入gpuimage多种滤镜

## RTMP推荐开源服务器:
----------------------
推荐多媒体流媒体服务: [cpp_media_server](https://github.com/runner365/cpp_media_server)

支持跨平台(linux/mac)

### 直播相关特性
* rtmp推拉流服务(支持h264/vp8+aac/opus in rtmp/flv)
* httpflv拉流服务(支持h264/vp8+aac/opus in rtmp/flv)
* hls录像服务(支持h264/vp8+aac/opus in mpegts)
* webobs: websocket推送flv直播服务(webcodec编码，websocket flv推流封装)

### webrtc视频会议特性
* 房间管理服务
* websocket长连接接入
* 加入/离开房间
* 推流/停止推流
* 拉流/停止拉流
* 高性能webrtc转rtmp: 无转码
* 高性能支持webrtc的旁路rtmp直播
* 高性能rtmp转webrtc: 无转码
* 高性能支持低延时直播，支持rtmp转为webrtc
