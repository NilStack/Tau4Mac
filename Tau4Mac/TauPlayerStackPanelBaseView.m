//
//  TauPlayerStackPanelBaseView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauPlayerStackPanelBaseView.h"

// TauPlayerStackPanelBaseView class
@interface TauPlayerStackPanelBaseView ()

@property ( strong, readonly ) XCDYouTubeClient* ytClient_;
@property ( strong, readonly ) AVPlayer* corePlayer_;
@property ( strong, readonly ) AVPlayerView* playerView_;

- ( void ) doPlayerViewInit_;

@end // TauPlayerStackPanelBaseView class

// TauPlayerStackPanelBaseView class
@implementation TauPlayerStackPanelBaseView
    {
    XCDYouTubeClient __strong* ytClient_;
    GTLObject __strong* ytContent_;
    AVPlayerView __strong* playerView_;
    }

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self doPlayerViewInit_ ];
    return self;
    }

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        [ self doPlayerViewInit_ ];
    return self;
    }

#pragma mark - Dynamic Properties

@dynamic ytContent;

- ( void ) setYtContent: ( GTLObject* )_New
    {
    if ( ytContent_ != _New )
        {
        ytContent_ = _New;

        if ( self.corePlayer_ )
            [ self.corePlayer_ replaceCurrentItemWithPlayerItem: nil ];

        NSString* videoID = nil;
        if ( [ ytContent_ isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
            videoID = [ ( GTLYouTubePlaylistItem* )ytContent_ contentDetails ].videoId;
        else if ( [ ytContent_ isKindOfClass: [ GTLYouTubeVideo class ] ] )
            videoID = [ ( GTLYouTubeVideo* )ytContent_ identifier ];
        else if ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
            {
            GTLYouTubeResourceId* resourceID = [ ( GTLYouTubeSearchResult* )ytContent_ identifier ];

            if ( [ resourceID.kind isEqualToString: @"youtube#video" ] )
                videoID = resourceID.JSON[ @"videoId" ];
            }

        if ( videoID )
            {
            [ self.ytClient_ getVideoWithIdentifier: videoID
                                  completionHandler:
            ^( XCDYouTubeVideo* _Nullable _Video, NSError* _Nullable _Error )
                {
                NSDictionary* streamURLs = _Video.streamURLs;
                NSURL* preferURL =
                    streamURLs[ XCDYouTubeVideoQualityHTTPLiveStreaming ]
                        ?: streamURLs[ @( XCDYouTubeVideoQualityHD720 ) ]
                        ?: streamURLs[ @( XCDYouTubeVideoQualityMedium360 ) ]
                        ?: streamURLs[ @( XCDYouTubeVideoQualitySmall240 ) ];

                AVPlayerItem* playerItem = [ AVPlayerItem playerItemWithURL: preferURL ];
                AVPlayer* player = nil;
                if ( self.corePlayer_ )
                    {
                    [ self.corePlayer_ replaceCurrentItemWithPlayerItem: playerItem ];
                    player = self.corePlayer_;
                    }
                else
                    {
                    player = [ [ AVPlayer alloc ] initWithPlayerItem: playerItem ];
                    [ self.playerView_ setPlayer: player ];
                    }

                [ player play ];
                } ];
            }
        else
            // TODO: Change log method from DDLogWarn() to DDLogUnexpected()
            DDLogWarn( @"videoID has an unexpected value: %@", videoID );
        }
    }

- ( GTLObject* ) ytContent
    {
    return ytContent_;
    }

#pragma mark - Private Interfaces

@dynamic ytClient_;
@dynamic corePlayer_;
@dynamic playerView_;

- ( XCDYouTubeClient* ) ytClient_
    {
    if ( !ytClient_ )
        ytClient_ = [ XCDYouTubeClient defaultClient ];
    return ytClient_;
    }

- ( AVPlayer* ) corePlayer_
    {
    return self.playerView_.player;
    }

- ( AVPlayerView* ) playerView_
    {
    if ( !playerView_ )
        {
        playerView_ = [ [ AVPlayerView alloc ] initWithFrame: NSZeroRect ];
        playerView_.controlsStyle = AVPlayerViewControlsStyleFloating;
        playerView_.showsFrameSteppingButtons = YES;

        [ playerView_ configureForAutoLayout ];
        [ self addSubview: playerView_ ];
        [ playerView_ autoPinEdgesToSuperviewEdges ];
        }

    return playerView_;
    }

- ( void ) doPlayerViewInit_
    {
    // Force to load the AVPlayerView
    if ( !self.playerView_ )
        DDLogError( @"Goddamn it! Failed to load AVPlayerView" );
    }

@end // TauPlayerStackPanelBaseView class