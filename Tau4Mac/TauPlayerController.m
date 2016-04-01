//
//  TauPlayerController.m
//  Tau4Mac
//
//  Created by Tong G. on 4/1/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauPlayerController.h"
#import "TauToolbarController.h"

// Private
@interface TauPlayerController ()

@property ( strong, readonly ) AVQueuePlayer* queuePlayer_;

@end // Private

// TauPlayerController class
@implementation TauPlayerController

#pragma mark - UI Elements

@synthesize playerView = priPlayerView_;
- ( AVPlayerView* ) playerView
    {
    if ( !priPlayerView_ )
        {
        priPlayerView_ = [ [ AVPlayerView alloc ] initWithFrame: NSZeroRect ];

        [ priPlayerView_ setControlsStyle: AVPlayerViewControlsStyleFloating ];
        [ priPlayerView_ setPlayer: self.queuePlayer_ ];
        }

    return priPlayerView_;
    }

#pragma mark - Player Operations

- ( void ) playYouTubeVideo: ( GTLObject* )_YouTubeObject switchToPlayer: ( BOOL )_Flag
    {
    if ( _YouTubeObject.tauContentType != TauYouTubeVideo )
        {
        DDLogFatal( @"%@ can play only video.", THIS_METHOD );
        return;
        }

    NSString* videoIdentifier = nil;
    if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
        videoIdentifier = [ _YouTubeObject valueForKeyPath: @"contentDetails.videoId" ];
    else if ( [ _YouTubeObject isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
        videoIdentifier = [ ( GTLYouTubeSearchResult* )_YouTubeObject identifier ].JSON[ @"videoId" ];

    [ self playYouTubeVideoWithVideoIdentifier: videoIdentifier switchToPlayer: _Flag ];
    }

- ( void ) playYouTubeVideoWithVideoIdentifier: ( NSString* )_VideoIdentifier switchToPlayer: ( BOOL )_Flag
    {
    if ( _Flag )
        [ [ TauToolbarController sharedController ] setContentViewAffiliatedTo: TauPlayerContentViewTag ];

    [ [ XCDYouTubeClient defaultClient ]
        getVideoWithIdentifier: _VideoIdentifier
             completionHandler:
        ^( XCDYouTubeVideo* _Nullable _Video, NSError* _Nullable _Error )
            {
            if ( _Video )
                {
                NSDictionary* streamURLs = _Video.streamURLs;
                NSURL* preferURL =
                    streamURLs[ XCDYouTubeVideoQualityHTTPLiveStreaming ]
                        ?: streamURLs[ @( XCDYouTubeVideoQualityHD720 ) ]
                        ?: streamURLs[ @( XCDYouTubeVideoQualityMedium360 ) ]
                        ?: streamURLs[ @( XCDYouTubeVideoQualitySmall240 ) ];

                AVPlayerItem* playerItem = [ AVPlayerItem playerItemWithURL: preferURL ];
                [ self.queuePlayer_ replaceCurrentItemWithPlayerItem: playerItem ];
                [ self.queuePlayer_ play ];
                }
            } ];
    }

#pragma mark - Singleton

TauPlayerController static* sPlayerController;
+ ( instancetype ) defaultPlayerController
    {
    return [ [ TauPlayerController alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( !sPlayerController )
        if ( self = [ super init ] )
            sPlayerController = self;

    return sPlayerController;
    }

@synthesize queuePlayer_ = priQueuePlayer_;
- ( AVQueuePlayer* ) queuePlayer_
    {
    if ( !priQueuePlayer_ )
        priQueuePlayer_ = [ AVQueuePlayer queuePlayerWithItems: @[] ];
    return priQueuePlayer_;
    }

@end // TauPlayerController class