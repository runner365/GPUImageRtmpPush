//
//  LibRtmpSessionMgr.hpp
//  Pods
//
//  Created by Alex.Shi on 16/3/9.
//
//

#ifndef LibRtmpSession_hpp
#define LibRtmpSession_hpp

#include <iostream>
#include <videocore/stream/IStreamSession.hpp>
#include <videocore/stream/TCPThroughputAdaptation.h>

#include <UriParser/UriParser.hpp>

#include <functional>
#include <deque>
#include <queue>
#include <map>
#include <chrono>

#include <videocore/system/JobQueue.hpp>
#include <cstdlib>

#include <videocore/rtmp/RTMPTypes.h>
#include <videocore/system/Buffer.hpp>
#include <videocore/transforms/IOutputSession.hpp>

class LibRtmpSession;

namespace videocore
{
    typedef struct _RTMP_QUEUE_ITEM{
        unsigned long ulLength;
        unsigned int  uiType;
        unsigned int  uiTimestamp;
        unsigned char* pRtmpBody;
    }RTMP_QUEUE_ITEM;
    
    class RTMP_Queue_Manager{
    public:
        RTMP_Queue_Manager();
        ~RTMP_Queue_Manager();
        int InsertQueue(unsigned int uiType,
                        unsigned int uiLength,
                        unsigned int uiTimestamp,
                        bool bIsKey,
                        unsigned char* pData);
        RTMP_QUEUE_ITEM* ReadQueueAndRelease();
        
        void CleanQueue();
        unsigned int GetQueueLength();
    private:
        int _iMaxQueueLength1;
        int _iMaxQueueLength2;
        std::queue<RTMP_QUEUE_ITEM*> _sendDataQueue;
        pthread_mutex_t _mConnstatMutex;
    };
    
    typedef MetaData<'rtmp', int32_t, int32_t, double, int32_t, double, bool> LibRTMPSessionParameters_t;
    enum {
        kLibRTMPSessionParameterWidth=0,
        kLibRTMPSessionParameterHeight,
        kLibRTMPSessionParameterFrameDuration,
        kLibRTMPSessionParameterVideoBitrate,
        kLibRTMPSessionParameterAudioFrequency,
        kLibRTMPSessionParameterStereo
    };
    
    typedef MetaData<'rtmp', int32_t, int32_t, uint8_t, int32_t, bool> LibRTMPMetadata_t;
    enum {
        kLibRTMPMetadataTimestamp=0,
        kLibRTMPMetadataMsgLength,
        kLibRTMPMetadataMsgTypeId,
        kLibRTMPMetadataMsgStreamId,
        kLibRTMPMetadataIsKeyframe
    };
    
    class LibRtmpSessionMgr;
    
    using LibRTMPSessionStateCallback = std::function<void(LibRtmpSessionMgr& session, ClientState_t state)>;

    class LibRtmpSessionMgr : public IOutputSession
    {
    public:
        LibRtmpSessionMgr(std::string uri, LibRTMPSessionStateCallback callback);
        ~LibRtmpSessionMgr();
        
    public:
        virtual void pushBuffer(const uint8_t* const data, size_t size, IMetadata& metadata);
        virtual int getConnectFlag();
        virtual void setEndFlag(int iFlag);
        void setSessionParameters(IMetadata& parameters);
        void setBandwidthCallback(BandwidthCallback callback);
        
        double getVideoSentBytes(){
            return _fVideoSentBytes;
        }
        
        double getAudioSentBytes(){
            return _fAudioSentBytes;
        }
        
        void setVideoSentBytes(double fParam){
            _fVideoSentBytes = fParam;
        }
        
        void setAudioSentBytes(double fParam){
            _fAudioSentBytes = fParam;
        }
    private:
        LibRtmpSession* _rtmpSession;
        LibRTMPSessionStateCallback        m_callback;
        char _szRtmpUrl[256];
        
        int    _bitRate;
        double _frameDuration;
        int    _frameHeight;
        int    _frameWidth;
        double _audioSampleRate;
        int    _audioStereo;
        
        JobQueue            m_jobQueue;
        JobQueue            m_sendQueue;
        
        RTMP_Queue_Manager _rtmpSendQueueManager;
        int _iEndFlag;
        
        double _fVideoSentBytes;
        double _fAudioSentBytes;
    };
}
#endif /* LibRtmpSession_hpp */
