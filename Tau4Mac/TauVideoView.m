//
//  TauVideoView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauVideoView.h"
#import "OAuthSigningConstants.h"

// Private Interfaces
@interface TauVideoView ()

// Init
- ( void ) doInit_;

@end // Private Interfaces

// TauVideoView class
@implementation TauVideoView
    {
@private
    NSImage __strong* thumbnailImage_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self doInit_ ];
    return self;
    }

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        [ self doInit_ ];
    return self;
    }

- ( instancetype ) initWithGTLObject: ( GTLObject* )_GTLObject
    {
    if ( self = [ self initWithFrame: NSZeroRect ] )
        self.ytVideo = _GTLObject;
    return self;
    }

#pragma mark - Core Animations

- ( CALayer* ) makeBackingLayer
    {
    return [ [ CALayer alloc ] init ];
    }

- ( void ) displayLayer: ( CALayer* )_Layer
    {
    self.layer.contents = thumbnailImage_;
    }

#pragma mark - Properties

@dynamic ytVideo;

- ( void ) setYtVideo: ( GTLObject* )_ytVideo
    {
    DDAssert( ( !( _ytVideo ) )
                || [ _ytVideo isKindOfClass: [ GTLYouTubeVideo class ] ]
                || ( [ _ytVideo isKindOfClass: [ GTLYouTubeSearchResult class ] ]
                        && [ [ ( GTLYouTubeSearchResult* )_ytVideo identifier ].kind isEqualToString: @"youtube#video" ] )
            , @"[%@] isn't a YouTube video, YouTube search result that is kind of youtube#video or nil."
            , _ytVideo
            );

    if ( ytVideo_ != _ytVideo )
        {
        ytVideo_ = _ytVideo;

        NSURL* highestDefinitionThumbnailURL = nil;
        GTLYouTubeThumbnailDetails* thumbnailDetails = nil;

        if ( [ ytVideo_ isKindOfClass: [ GTLYouTubeVideo class ] ] )
            {
            GTLYouTubeVideoSnippet* videoSnippet = [ ( GTLYouTubeVideo* )ytVideo_ snippet ];
            thumbnailDetails = videoSnippet.thumbnails;
            }

        else if ( [ ytVideo_ isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
            {
            GTLYouTubeSearchResultSnippet* searchResultSnippet = [ ( GTLYouTubeSearchResult* )ytVideo_ snippet ];
            thumbnailDetails = searchResultSnippet.thumbnails;
            }

        GTLYouTubeThumbnail* preferThumbnail =
                /* 1280x720 px */
            thumbnailDetails.maxres
                /* 640x480 px */
                ?: thumbnailDetails.standard
                /* 480x360 px */
                ?: thumbnailDetails.high
                /* 320x180 px */
                ?: thumbnailDetails.medium
                /* 120x90 px */
                ?: thumbnailDetails.defaultProperty;

        highestDefinitionThumbnailURL = [ NSURL URLWithString: preferThumbnail.url ];

        DDLogDebug( @"Selected Thumbnail: %@", highestDefinitionThumbnailURL );

        NSString* fetchID = [ NSString stringWithFormat: @"(fetchID: %@)", TKNonce() ];
        DDLogDebug( @"Begin fetching thumbnail... %@", fetchID );
        GTMSessionFetcher* fetcher = [ GTMSessionFetcher fetcherWithURL: highestDefinitionThumbnailURL ];
        [ fetcher setComment: fetchID ];
        [ fetcher beginFetchWithCompletionHandler:
            ^( NSData* _Nullable _Data, NSError* _Nullable _Error )
                {
                if ( _Data && !_Error )
                    {
                    DDLogDebug( @"Finished fetching thumbnail %@", fetchID );
                    thumbnailImage_ = [ [ NSImage alloc ] initWithData: _Data ];
                    [ self.layer setNeedsDisplay ];
                    }
                else
                    DDLogError( @"%@ (%@)", _Error, fetcher.comment );
                } ];
        }
    }

- ( GTLObject* ) ytVideo
    {
    return ytVideo_;
    }

#pragma mark - Private Interfaces

// Init
- ( void ) doInit_
    {
    self.wantsLayer = YES;
    self.layer.delegate = self;
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawNever;
    self.layerContentsPlacement = NSViewLayerContentsPlacementScaleProportionallyToFit;

    [ self configureForAutoLayout ];
    [ self autoSetDimension: ALDimensionWidth toSize: 120 relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self autoMatchDimension: ALDimensionHeight toDimension: ALDimensionWidth ofView: self withMultiplier: 9.f / 16.f ];
    }

@end // TauVideoView class