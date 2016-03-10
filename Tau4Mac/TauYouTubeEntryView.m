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
#import "TauYouTubePlaylistSummaryView.h"
#import "TauYouTubeChannelBadge.h"
#import "TauPlayerStackPanelBaseViewController.h"
#import "TauEntryMosEnteredInteractionView.h"
#import "TauEntryMosExitedInteractionView.h"
#import "TauMosEnteredInteractionButton.h"

#import "NSImage+Tau.h"

#import "PriTauYouTubeContentView_.h"

// Private Interfaces
@interface TauYouTubeEntryView ()

@property ( assign, readwrite, setter = setProgressIndicatorHidden_: ) BOOL isProgressIndicatorHidden_;

@property ( assign, readwrite, setter = setMosEnteredInteractionViewHidden_: ) BOOL isMosEnteredInteractionViewHidden_;
@property ( assign, readwrite, setter = setMosExitedInteractionViewHidden_: ) BOOL isMosExitedInteractionViewHidden_;

@property ( strong, readonly ) NSProgressIndicator* progressIndicator_;

// Mouse Entered
@property ( strong, readonly ) TauEntryMosEnteredInteractionView* mosEnteredInteractionView_;
@property ( strong, readonly ) NSMutableArray <NSLayoutConstraint*>* mosEnteredLayoutConstraintsCache_;

// Mouse Exited
@property ( strong, readonly ) TauEntryMosExitedInteractionView* mosExitedInteractionView_;
@property ( strong, readonly ) NSMutableArray <NSLayoutConstraint*>* mosExitedLayoutConstraintsCache_;

- ( void ) cleanUp_;

// Actions
- ( void ) forwardActionOfInteractionButton_: ( id )_Sender;

@end // Private Interfaces

// TauYouTubeEntryView class
@implementation TauYouTubeEntryView
    {
@protected
    NSImage __strong* thumbnailImage_;
    GTLObject __strong* ytContent_;

    NSProgressIndicator __strong* priProgressIndicator_;

    // Mouse Entered
    TauEntryMosEnteredInteractionView __strong*     priMosEnteredInteractionView_;
    NSMutableArray <NSLayoutConstraint*> __strong*  priMosEnteredLayoutConstraintsCache_;

    // Mouse Exited
    TauEntryMosExitedInteractionView __strong*      priMosExitedInteractionView_;
    NSMutableArray <NSLayoutConstraint*>__strong*   priMosExitedLayoutConstraintsCache_;
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
    return [ [ TauYouTubeEntryLayer alloc ] init ];
    }

- ( void ) displayLayer: ( CALayer* )_Layer
    {
    switch ( self.type )
        {
        case TauYouTubeVideoView:
        case TauYouTubePlayListView:
        case TauYouTubePlayListItemView:
            {
            self.layer.contents = thumbnailImage_;
            } break;

        case TauYouTubeChannelView:
            {
            self.layer.contents = [ thumbnailImage_ gaussianBluredOfRadius: 10.f ];
            } break;

        default:
            self.layer.contents = nil;
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

    else if ( [ ytContent_ isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
        type = TauYouTubePlayListItemView;

    return type;
    }

#pragma mark - Events

- ( void ) mouseEntered: ( NSEvent* )_Event
    {
    if ( thumbnailImage_ )
        {
        self.isMosExitedInteractionViewHidden_ = YES;
        self.isMosEnteredInteractionViewHidden_ = NO;
        }
    }

- ( void ) mouseExited: ( NSEvent* )_Event
    {
    if ( thumbnailImage_ )
        {
        self.isMosExitedInteractionViewHidden_ = NO;
        self.isMosEnteredInteractionViewHidden_ = YES;
        }
    }

#pragma mark - Private Interfaces

@dynamic progressIndicator_;

@dynamic isProgressIndicatorHidden_;
@dynamic isMosEnteredInteractionViewHidden_;
@dynamic isMosExitedInteractionViewHidden_;

- ( NSProgressIndicator* ) progressIndicator_
    {
    if ( !priProgressIndicator_ )
        {
        priProgressIndicator_ = [ [ NSProgressIndicator alloc ] initWithFrame: NSZeroRect ];
        priProgressIndicator_.style = NSProgressIndicatorBarStyle;

        [ self addSubview: [ priProgressIndicator_ configureForAutoLayout ] ];
        [ priProgressIndicator_ autoSetDimensionsToSize: NSMakeSize( 60.f, 20.f ) ];
        [ priProgressIndicator_ autoAlignAxisToSuperviewAxis: ALAxisHorizontal ];
        [ priProgressIndicator_ autoAlignAxisToSuperviewAxis: ALAxisVertical ];

        self.isProgressIndicatorHidden_ = YES;
        }

    return priProgressIndicator_;
    }

- ( void ) setProgressIndicatorHidden_: ( BOOL )_Flag
    {
    [ self.progressIndicator_ setHidden: _Flag ];
TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_BEGIN
    [ self.progressIndicator_ performSelector: _Flag ? @selector( stopAnimation: ) : @selector( startAnimation: ) withObject: self ];
TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING_COMMIT
    }

- ( BOOL ) isProgressIndicator_
    {
    return self.progressIndicator_.isHidden;
    }

- ( void ) setMosEnteredInteractionViewHidden_: ( BOOL )_Flag
    {
    [ self.mosEnteredInteractionView_ setHidden: _Flag ];

    _Flag ? [ NSLayoutConstraint deactivateConstraints: self.mosEnteredLayoutConstraintsCache_ ]
          : [ NSLayoutConstraint activateConstraints: self.mosEnteredLayoutConstraintsCache_ ];
    }

- ( BOOL ) isMosEnteredInteractionViewHidden_
    {
    return self.mosEnteredInteractionView_.hidden;
    }

- ( void ) setMosExitedInteractionViewHidden_: ( BOOL )_Flag
    {
    [ self.mosExitedInteractionView_ setHidden: _Flag ];

    _Flag ? [ NSLayoutConstraint deactivateConstraints: self.mosExitedLayoutConstraintsCache_ ]
          : [ NSLayoutConstraint activateConstraints: self.mosExitedLayoutConstraintsCache_ ];
    }

- ( BOOL ) isMosExitedInteractionViewHidden_
    {
    return self.mosExitedInteractionView_.hidden;
    }

// Mouse Entered
@dynamic mosEnteredInteractionView_;
@dynamic mosEnteredLayoutConstraintsCache_;

- ( TauEntryMosEnteredInteractionView* ) mosEnteredInteractionView_
    {
    if ( !priMosEnteredInteractionView_ )
        {
        priMosEnteredInteractionView_ = [ [ TauEntryMosEnteredInteractionView alloc ] initWithGTLObject: ytContent_ host: self ];

        [ self addSubview: priMosEnteredInteractionView_ ];

        [ self.mosEnteredLayoutConstraintsCache_ removeAllObjects ];
        [ self.mosEnteredLayoutConstraintsCache_ addObjectsFromArray: [ priMosEnteredInteractionView_ autoPinEdgesToSuperviewEdges ] ];

        [ priMosEnteredInteractionView_ setHidden: YES ];
        [ NSLayoutConstraint deactivateConstraints: self.mosEnteredLayoutConstraintsCache_ ];
        }

    priMosEnteredInteractionView_.interactionButton.action = @selector( forwardActionOfInteractionButton_: );
    priMosEnteredInteractionView_.interactionButton.target = self;

    return priMosEnteredInteractionView_;
    }

- ( NSMutableArray <NSLayoutConstraint*>* ) mosEnteredLayoutConstraintsCache_
    {
    if ( !priMosEnteredLayoutConstraintsCache_ )
        priMosEnteredLayoutConstraintsCache_ = [ NSMutableArray array ];

    return priMosEnteredLayoutConstraintsCache_;
    }

// Mouse Exited
@dynamic mosExitedInteractionView_;
@dynamic mosExitedLayoutConstraintsCache_;

- ( TauEntryMosExitedInteractionView* ) mosExitedInteractionView_
    {
    if ( !priMosExitedInteractionView_ )
        {
        priMosExitedInteractionView_ = [ [ TauEntryMosExitedInteractionView alloc ] initWithGTLObject: ytContent_ host: self thumbnail: thumbnailImage_ ];

        [ self addSubview: priMosExitedInteractionView_ ];

        [ self.mosExitedLayoutConstraintsCache_ removeAllObjects ];
        [ self.mosExitedLayoutConstraintsCache_ addObjectsFromArray: [ priMosExitedInteractionView_ autoPinEdgesToSuperviewEdges ] ];

        [ priMosExitedInteractionView_ setHidden: YES ];
        [ NSLayoutConstraint deactivateConstraints: self.mosExitedLayoutConstraintsCache_ ];
        }

    return priMosExitedInteractionView_;
    }

- ( NSMutableArray <NSLayoutConstraint*>* ) mosExitedLayoutConstraintsCache_
    {
    if ( !priMosExitedLayoutConstraintsCache_ )
        priMosExitedLayoutConstraintsCache_ = [ NSMutableArray array ];

    return priMosExitedLayoutConstraintsCache_;
    }

- ( void ) cleanUp_
    {
    priMosEnteredInteractionView_.ytContent = nil;
    priMosExitedInteractionView_.ytContent = nil;

    thumbnailImage_ = nil;
    [ self.layer setNeedsDisplay ];
    }

// Actions
- ( void ) forwardActionOfInteractionButton_: ( id )_Sender
    {
    if ( self.action )
        [ self.target performSelectorOnMainThread: self.action withObject: self waitUntilDone: NO ];
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
    [ self autoMatchDimension: ALDimensionHeight toDimension: ALDimensionWidth ofView: self withMultiplier: 0.56f ];

    NSTrackingArea* mouseEventTrackingArea =
        [ [ NSTrackingArea alloc ] initWithRect: self.bounds
                                        options: NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
                                          owner: self
                                       userInfo: nil ];
    [ self addTrackingArea: mouseEventTrackingArea ];
    }

NSString* const kPreferredThumbKey = @"kPreferredThumbKey";
NSString* const kBackingThumbKey = @"kBackingThumbKey";

// Content
- ( void ) updateYtContent_: ( GTLObject* )_ytContent
    {
    if ( ytContent_ != _ytContent )
        {
        ytContent_ = _ytContent;

        if ( !ytContent_ )
            {
            [ self cleanUp_ ];
            return;
            }

        NSURL* backingThumb = nil;
        NSURL* preferredThumb = nil;

        GTLObject* snippet = nil;
        if ( [ ytContent_ isKindOfClass: [ GTLYouTubeVideo class ] ] )
            snippet = [ ( GTLYouTubeVideo* )ytContent_ snippet ];

        else if ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ] )
            snippet = [ ( GTLYouTubeSearchResult* )ytContent_ snippet ];

        else if ( [ ytContent_ isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
            snippet = [ ( GTLYouTubePlaylistItem* )ytContent_ snippet ];

        // snippet is kind of either GTLYouTubeVideoSnippet or GTLYouTubeSearchResultSnippet
        // both two classes response `thumbnails` selector correctly

        GTLYouTubeThumbnailDetails* thumbnailDetails = [ snippet performSelector: @selector( thumbnails ) withObject: nil ];

        if ( !thumbnailDetails )
            {
            NSSize imageSize = self.bounds.size;
            NSImage* replacement = [ NSImage imageWithSize: imageSize
                                                   flipped: NO
                                            drawingHandler:
            ^BOOL ( NSRect _DstRect )
                {
                [ [ NSColor blackColor ] set ];
                NSRectFill( _DstRect );

                NSString* noCover = @"NO COVER";
                NSDictionary* attrs = @{ NSForegroundColorAttributeName : [ NSColor whiteColor ]
                                       , NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue Light" size: 15 ]
                                       };

                NSSize size = [ noCover sizeWithAttributes: attrs ];
                [ noCover drawAtPoint: NSMakePoint( ( NSWidth( _DstRect ) * .6f - size.width ) / 2, ( NSHeight( _DstRect ) - size.height ) / 2 ) withAttributes: attrs ];

                return YES;
                } ];

            thumbnailImage_ = replacement;
            [ self updateUI_ ];
            return;
            }

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

        self.isProgressIndicatorHidden_ = NO;
        [ fetcher beginFetchWithCompletionHandler:
        ^( NSData* _Nullable _Data, NSError* _Nullable _Error )
            {
            if ( _Data && !_Error )
                {
                DDLogDebug( @"Finished fetching thumbnail %@", fetchID );
                thumbnailImage_ = [ [ NSImage alloc ] initWithData: _Data ];
                [ self.mosExitedInteractionView_ setThumbnail: thumbnailImage_ ];
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

                self.isProgressIndicatorHidden_ = YES;
                }
            } ];
        }
    }

- ( void ) updateUI_
    {
    [ self.layer setContents: nil ];
    [ self.layer setNeedsDisplay ];

    self.isMosExitedInteractionViewHidden_ = NO;
    self.isMosEnteredInteractionViewHidden_ = YES;

    [ self.mosEnteredInteractionView_ setYtContent: ytContent_ ];
    [ self.mosExitedInteractionView_ setYtContent: ytContent_ ];

    self.isProgressIndicatorHidden_ = YES;
    }

@end // TauYouTubeEntryView + PriTauYouTubeContentView_