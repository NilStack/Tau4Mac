//
//  TauVideoView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauVideoView.h"
#import "OAuthSigningConstants.h"
#import "TauItemLayer.h"

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
        self.ytContent = _GTLObject;
    return self;
    }

#pragma mark - Core Animations

- ( CALayer* ) makeBackingLayer
    {
    return [ [ TauItemLayer alloc ] init ];
    }

- ( void ) displayLayer: ( CALayer* )_Layer
    {
    self.layer.contents = thumbnailImage_;
    }

#pragma mark - Properties

@dynamic ytContent;

- ( void ) setYtContent: ( GTLObject* )_ytVideo
    {
    DDAssert( ( !( _ytVideo ) )
                || [ _ytVideo isKindOfClass: [ GTLYouTubeVideo class ] ]
                || ( [ _ytVideo isKindOfClass: [ GTLYouTubeSearchResult class ] ]
                        && [ [ ( GTLYouTubeSearchResult* )_ytVideo identifier ].kind isEqualToString: @"youtube#video" ] )
            , @"[%@] isn't a YouTube video, YouTube search result that is kind of youtube#video or nil."
            , _ytVideo
            );

    if ( ytContent_ != _ytVideo )
        {
        ytContent_ = _ytVideo;

        NSURL* preferred = nil;
        GTLYouTubeThumbnailDetails* thumbnailDetails = nil;

        if ( [ ytContent_ isKindOfClass: [ GTLYouTubeVideo class ] ] )
            {
            GTLYouTubeVideoSnippet* videoSnippet = [ ( GTLYouTubeVideo* )ytContent_ snippet ];
            thumbnailDetails = videoSnippet.thumbnails;
            }

        else if ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
            {
            GTLYouTubeSearchResultSnippet* searchResultSnippet = [ ( GTLYouTubeSearchResult* )ytContent_ snippet ];
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

        preferred = [ NSURL URLWithString: preferThumbnail.url ];

        NSString* maxresName = @"maxresdefault.jpg";
        NSURL* maxresURL = nil;
        if ( ![ [ preferred.lastPathComponent stringByDeletingPathExtension ] isEqualToString: maxresName ] )
            maxresURL = [ [ preferred URLByDeletingLastPathComponent ] URLByAppendingPathComponent: maxresName ];

        NSString* fetchID = [ NSString stringWithFormat: @"(fetchID: %@)", TKNonce() ];
        DDLogDebug( @"Begin fetching thumbnail... %@", fetchID );
        GTMSessionFetcher* fetcher = [ GTMSessionFetcher fetcherWithURL: maxresURL ];
        [ fetcher setComment: fetchID ];
        [ fetcher setUserData: @{ @"backup" : preferred } ];
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
                    {
                    DDLogError( @"[%@] %@ (%@)", maxresURL, _Error, fetcher.comment );

                    if ( [ _Error.domain isEqualToString: kGTMSessionFetcherStatusDomain ] )
                        {
                        if ( _Error.code == 404 )
                            {
                            [ [ GTMSessionFetcher fetcherWithURL: fetcher.userData[ @"backup" ] ]
                                beginFetchWithCompletionHandler:
                                ^( NSData* _Nullable _Data, NSError* _Nullable _Error )
                                    {
                                    DDLogDebug( @"Finished fetching thumbnail %@", fetchID );
                                    thumbnailImage_ = [ [ NSImage alloc ] initWithData: _Data ];
                                    [ self.layer setNeedsDisplay ];
                                    } ];
                            }
                        }
                    }
                } ];
        }
    }

- ( GTLObject* ) ytContent
    {
    return ytContent_;
    }

#pragma mark - Private Interfaces

// Init
- ( void ) doInit_
    {
    self.wantsLayer = YES;
    self.layer.delegate = self;
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawNever;
    self.layerContentsPlacement = NSViewLayerContentsPlacementScaleProportionallyToFill;

    [ self configureForAutoLayout ];
    [ self autoSetDimension: ALDimensionWidth toSize: 200 relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self autoMatchDimension: ALDimensionHeight toDimension: ALDimensionWidth ofView: self withMultiplier: 9.f / 16.f ];
    }

@end // TauVideoView class