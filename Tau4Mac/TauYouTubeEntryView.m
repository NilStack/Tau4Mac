//
//  TauYouTubeEntryView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYouTubeEntryView.h"
#import "OAuthSigningConstants.h"
#import "TauYouTubeEntryLayer.h"
#import "PriTauYouTubeContentView_.h"

#import "NSImage+Tau.h"

// Private Interfaces
@interface TauYouTubeEntryView ()
@end // Private Interfaces

// TauYouTubeEntryView class
@implementation TauYouTubeEntryView

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
    return [ [ TauYouTubeEntryLayer alloc ] init ];
    }

- ( void ) displayLayer: ( CALayer* )_Layer
    {
    switch ( self.type )
        {
        case TauYouTubeVideoView:
            {
            self.layer.contents = thumbnailImage_;
            } break;

        case TauYouTubeChannelView:
            {
            self.layer.contents = [ thumbnailImage_ gaussianBluredOfRadius: 10.f ];
            } break;

        default:;
        }
    }

#pragma mark - Properties

@dynamic ytContent;
@dynamic type;

- ( void ) setYtContent: ( GTLObject* )_ytContent
    {
    [ self updateYtContent_: _ytContent ];
    }

- ( GTLObject* ) ytContent
    {
    return ytContent_;
    }

- ( TauYouTubeContentViewType ) type
    {
    TauYouTubeContentViewType type = TauYouTubeUnknownView;

    if ( [ ytContent_ isKindOfClass: [ GTLYouTubeVideo class ] ]
            || ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ]
                    && [ [ ( GTLYouTubeSearchResult* )ytContent_ identifier ].kind isEqualToString: @"youtube#video" ] ) )
        type = TauYouTubeVideoView;

    else if ( [ ytContent_ isKindOfClass: [ GTLYouTubeChannel class ] ]
            || ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ]
                    && [ [ ( GTLYouTubeSearchResult* )ytContent_ identifier ].kind isEqualToString: @"youtube#channel" ] ) )
        type = TauYouTubeChannelView;

    else if ( [ ytContent_ isKindOfClass: [ GTLYouTubePlaylist class ] ]
            || ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ]
                    && [ [ ( GTLYouTubeSearchResult* )ytContent_ identifier ].kind isEqualToString: @"youtube#playlist" ] ) )
        type = TauYouTubePlayListView;

    return type;
    }

@end // TauYouTubeEntryView class

// TauYouTubeEntryView + PriTauYouTubeContentView_
@implementation TauYouTubeEntryView ( PriTauYouTubeContentView_ )

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

NSString* const kPreferredThumbKey = @"kPreferredThumbKey";
NSString* const kBackingThumbKey = @"kBackingThumbKey";

// Content
- ( void ) updateYtContent_: ( GTLObject* )_ytContent
    {
    if ( ytContent_ != _ytContent )
        {
        ytContent_ = _ytContent;

        NSURL* backingThumb = nil;
        NSURL* preferredThumb = nil;

        GTLObject* snippet = nil;
        if ( [ ytContent_ isKindOfClass: [ GTLYouTubeVideo class ] ] )
            snippet = [ ( GTLYouTubeVideo* )ytContent_ snippet ];
        else if ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
            snippet = [ ( GTLYouTubeSearchResult* )ytContent_ snippet ];

        // snippet is kind of either GTLYouTubeVideoSnippet or GTLYouTubeSearchResultSnippet
        // both two classes response `thumbnails` selector correctly

        GTLYouTubeThumbnailDetails* thumbnailDetails = [ snippet performSelector: @selector( thumbnails ) withObject: nil ];

        // Pick up the thumbnail that has the highest definition
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
                ?: thumbnailDetails.defaultProperty
                 ;

        backingThumb = [ NSURL URLWithString: preferThumbnail.url ];

        NSString* maxresName = @"maxresdefault.jpg";
        if ( ![ [ backingThumb.lastPathComponent stringByDeletingPathExtension ] isEqualToString: maxresName ] )
            preferredThumb = [ [ backingThumb URLByDeletingLastPathComponent ] URLByAppendingPathComponent: maxresName ];

        NSString* fetchID = [ NSString stringWithFormat: @"(fetchID: %@)", TKNonce() ];
        DDLogDebug( @"Begin fetching thumbnail... %@", fetchID );

        GTMSessionFetcher* fetcher = [ GTMSessionFetcher fetcherWithURL: preferredThumb ];
        [ fetcher setComment: fetchID ];
        [ fetcher setUserData: @{ kBackingThumbKey : backingThumb
                                , kPreferredThumbKey : preferredThumb
                                } ];

        [ fetcher beginFetchWithCompletionHandler:
            ^( NSData* _Nullable _Data, NSError* _Nullable _Error )
                {
                if ( _Data && !_Error )
                    {
                    DDLogDebug( @"Finished fetching thumbnail %@", fetchID );
                    thumbnailImage_ = [ [ NSImage alloc ] initWithData: _Data ];
                    [ self updateUI_ ];
                    }
                else
                    {
                    if ( [ _Error.domain isEqualToString: kGTMSessionFetcherStatusDomain ] )
                        {
                        if ( _Error.code == 404 )
                            {
                            DDLogError( @"404 NOT FOUND! There is no specific thumb (%@) %@ %@\n"
                                         "attempting to fetch the backing thumbnail…"
                                      , fetcher.userData[ kPreferredThumbKey ]
                                      , _Error
                                      , fetcher.comment
                                      );

                            [ [ GTMSessionFetcher fetcherWithURL: fetcher.userData[ kBackingThumbKey ] ]
                                beginFetchWithCompletionHandler:
                                ^( NSData* _Nullable _Data, NSError* _Nullable _Error )
                                    {
                                    DDLogDebug( @"Congrats! Finished fetching backing thumbnail" );
                                    thumbnailImage_ = [ [ NSImage alloc ] initWithData: _Data ];
                                    [ self updateUI_ ];
                                    } ];
                            }
                        }
                    }
                } ];
        }
    }

- ( void ) updateUI_
    {
    [ self.layer setNeedsDisplay ];

    if ( self.type == TauYouTubeChannelView )
        {
        NSButton* button = [ [ NSButton alloc ] initWithFrame: NSZeroRect ];
        [ button setTitle: @"CHANNEL" ];
        [ button sizeToFit ];
        [ button configureForAutoLayout ];
        [ self addSubview: button ];

        [ button autoPinEdge: ALEdgeTop toEdge: ALEdgeTop ofView: button.superview withOffset: 5.f ];
        [ button autoPinEdge: ALEdgeTrailing toEdge: ALEdgeTrailing ofView: button.superview withOffset: -5.f ];

        NSImageView* imageView = [ [ NSImageView alloc ] initWithFrame: NSZeroRect ];
        [ imageView setImageFrameStyle: NSImageFrameNone ];
        [ imageView setImage: thumbnailImage_ ];

        [ self addSubview: imageView ];
        [ imageView autoSetDimensionsToSize: NSMakeSize( 60.f, 60.f ) ];
        [ imageView autoPinEdge: ALEdgeTop toEdge: ALEdgeTop ofView: imageView.superview withOffset: 5.f ];
        [ imageView autoPinEdge: ALEdgeLeading toEdge: ALEdgeLeading ofView: imageView.superview withOffset: -5.f ];
        }
    }

@end // TauYouTubeEntryView + PriTauYouTubeContentView_