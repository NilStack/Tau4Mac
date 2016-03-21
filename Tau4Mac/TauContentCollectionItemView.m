//
//  TauContentCollectionItemView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionItemView.h"
#import "OAuthSigningConstants.h"
#import "TauContentCollectionItemSubLayer.h"
#import "TauContentCollectionItemBorderView.h"

#import "NSImage+Tau.h"

#import "PriTauYouTubeContentView_.h"

// Private Interfaces
@interface TauContentCollectionItemView ()
@property ( strong, readonly ) TauContentCollectionItemBorderView* borderView_;
@end // Private Interfaces



// ------------------------------------------------------------------------------------------------------------ //



// TauContentCollectionItemView class
@implementation TauContentCollectionItemView
    {
@protected
    NSImage __strong* thumbnailImage_;
    GTLObject __strong* ytContent_;

    TauContentCollectionItemBorderView __strong* priBorderView_;

    // Layout caches
    NSArray __strong* priBorderViewPinEdgesCache_;
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

- ( void ) updateLayer
    {
    CALayer* subLayer = [ [ CALayer alloc ] init ];
    [ subLayer setMasksToBounds: YES ];
    [ subLayer setContentsGravity: kCAGravityResizeAspectFill ];

    switch ( self.type )
        {
        case TauYouTubeVideo:
        case TauYouTubePlayList: subLayer.contents = thumbnailImage_;  break;
        case TauYouTubeChannel:  subLayer.contents = [ thumbnailImage_ gaussianBluredOfRadius: 10.f ]; break;
                       default:  subLayer.contents = nil;
        }

    [ self.layer setSublayers: @[ subLayer ] ];
    CAConstraintLayoutManager* sharedCALayoutManager = [ CAConstraintLayoutManager layoutManager ];
    [ self.layer setLayoutManager: sharedCALayoutManager ];

    [ subLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidX relativeTo: @"superlayer" attribute: kCAConstraintMidX ] ];
    [ subLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidY relativeTo: @"superlayer" attribute: kCAConstraintMidY ] ];
    [ subLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintWidth relativeTo: @"superlayer" attribute: kCAConstraintWidth offset: -10.f ] ];
    [ subLayer addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintHeight relativeTo: @"superlayer" attribute: kCAConstraintHeight offset: -10.f ] ];

    if ( isSelected_ )
        {
        TauContentCollectionItemBorderView* borderView = self.borderView_;
        [ borderView setBounds: self.bounds ];
        [ borderView setNeedsDisplay: YES ];

        [ self addSubview: borderView ];
        priBorderViewPinEdgesCache_ = [ borderView autoPinEdgesToSuperviewEdges ];
        }
    else
        {
        if ( priBorderViewPinEdgesCache_ && priBorderViewPinEdgesCache_.count > 0 )
            [ self removeConstraints: priBorderViewPinEdgesCache_ ];

        [ self.borderView_ removeFromSuperview ];
        }
    }

- ( BOOL ) wantsUpdateLayer
    {
    return YES;
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

- ( TauYouTubeContentType ) type
    {
    TauYouTubeContentType type = TauYouTubeUnknownContent;

    if ( [ ytContent_ isKindOfClass: [ GTLYouTubeVideo class ] ]
            || ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ]
                    && [ [ ( GTLYouTubeSearchResult* )ytContent_ identifier ].kind isEqualToString: @"youtube#video" ] ) )
        type = TauYouTubeVideo;

    else if ( [ ytContent_ isKindOfClass: [ GTLYouTubeChannel class ] ]
            || ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ]
                    && [ [ ( GTLYouTubeSearchResult* )ytContent_ identifier ].kind isEqualToString: @"youtube#channel" ] ) )
        type = TauYouTubeChannel;

    else if ( [ ytContent_ isKindOfClass: [ GTLYouTubePlaylist class ] ]
            || ( [ ytContent_ isKindOfClass: [ GTLYouTubeSearchResult class ] ]
                    && [ [ ( GTLYouTubeSearchResult* )ytContent_ identifier ].kind isEqualToString: @"youtube#playlist" ] ) )
        type = TauYouTubePlayList;

//    else if ( [ ytContent_ isKindOfClass: [ GTLYouTubePlaylistItem class ] ] )
//        type = TauYouTubePlayListItemView;

    return type;
    }

@synthesize isSelected = isSelected_;
- ( void ) setSelected: ( BOOL )_Flag
    {
    if ( isSelected_ != _Flag )
        {
        isSelected_ = _Flag;

        // Cause our -updateLayer method to be invoked, so we can update our appearance to reflect the new state.
        [ self setNeedsDisplay: YES ];
        }
    }

- ( BOOL ) isSelected
    {
    return isSelected_;
    }

@dynamic borderView_;
- ( TauContentCollectionItemBorderView* ) borderView_
    {
    if ( !priBorderView_ )
        priBorderView_ = [ [ TauContentCollectionItemBorderView alloc ] initWithFrame: self.bounds ];
    return priBorderView_;
    }

@end // TauContentCollectionItemView class



// ------------------------------------------------------------------------------------------------------------ //



// TauContentCollectionItemView + PriTauYouTubeContentView_
@implementation TauContentCollectionItemView ( PriTauYouTubeContentView_ )

// Init
- ( void ) doInit_
    {
    [ self configureForAutoLayout ].wantsLayer = YES;
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    self.layer.masksToBounds = YES;
//    self.layerContentsPlacement = NSViewLayerContentsPlacementScaleProportionallyToFill;

    NSTrackingArea* mouseEventTrackingArea =
        [ [ NSTrackingArea alloc ] initWithRect: self.bounds
                                        options: NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect
                                          owner: self
                                       userInfo: nil ];
    [ self addTrackingArea: mouseEventTrackingArea ];
    }

// Content
- ( void ) updateYtContent_: ( GTLObject* )_New
    {
    if ( ytContent_ != _New )
        {
        ytContent_ = _New;

        if ( !ytContent_ )
            {
//            [ self cleanUp_ ];
            return;
            }

        GTLYouTubeThumbnailDetails* thumbnailDetails = nil;
        @try {
        thumbnailDetails = [ self.ytContent valueForKeyPath: @"snippet.thumbnails" ];
        } @catch ( NSException* _Ex )
            {
            DDLogFatal( @"%@", _Ex );
            }

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

        thumbnailImage_ = nil;
        [ self updateUI_ ];
        [ [ TauYTDataService sharedService ] fetchPreferredThumbnailFrom: thumbnailDetails
                                                                 success:
        ^( NSImage* _Image, GTLYouTubeThumbnailDetails* _ThumbnailDetails, BOOL _LoadsFromCache )
            {
            if ( _ThumbnailDetails == [ self.ytContent valueForKeyPath: @"snippet.thumbnails" ] )
                {
                thumbnailImage_ = _Image;
                [ self updateUI_ ];
                }
            } failure:
                ^( NSError* _Error )
                    {
                    DDLogFatal( @"%@", _Error );
                    } ];
        }
    }

- ( void ) updateUI_
    {
    [ self.layer setContents: nil ];
    [ self.layer setNeedsDisplay ];
    }

@end // TauContentCollectionItemView + PriTauYouTubeContentView_