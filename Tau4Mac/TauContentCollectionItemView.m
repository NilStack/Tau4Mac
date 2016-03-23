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

#import "NSImage+Tau.h"
#import "NSColor+TauDrawing.h"

#import "PriTauYouTubeContentView_.h"

// _PriItemBorderView class
@interface _PriItemBorderView : NSView

#pragma mark - External Properties

@property ( strong, readwrite ) NSColor* borderColor;

@end // _PriItemBorderView class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauContentCollectionItemView ()

@property ( strong, readonly ) TauContentCollectionItemSubLayer* subLayer_;
@property ( strong, readonly ) _PriItemBorderView* borderView_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauContentCollectionItemView class
@implementation TauContentCollectionItemView
    {
@protected
    NSImage __strong* priThumbnailImage_;
    GTLObject __strong* ytContent_;

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

#pragma mark - Drawing

- ( void ) updateLayer
    {
    switch ( self.type )
        {
        case TauYouTubeVideo:
        case TauYouTubePlayList: self.subLayer_.contents = priThumbnailImage_;  break;
        case TauYouTubeChannel:  self.subLayer_.contents = [ priThumbnailImage_ gaussianBluredOfRadius: 10.f ]; break;
                       default:  self.subLayer_.contents = nil;
        }

    if ( isSelected_ || ( highlightState_ == NSCollectionViewItemHighlightForSelection ) )
        {
        _PriItemBorderView* borderView = self.borderView_;
        [ borderView setBorderColor: isSelected_ ? nil : [ NSColor lightGrayColor ] ];

        [ self addSubview: borderView ];
        priBorderViewPinEdgesCache_ = [ borderView autoPinEdgesToSuperviewEdges ];
        }
    else
        {
        if ( priBorderViewPinEdgesCache_ && priBorderViewPinEdgesCache_.count > 0 )
            [ self removeConstraints: priBorderViewPinEdgesCache_ ];

        if ( priBorderView_ )
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

    return type;
    }

@synthesize isSelected = isSelected_;
- ( void ) setSelected: ( BOOL )_Flag
    {
    if ( isSelected_ != _Flag )
        {
        isSelected_ = _Flag;

        // Cause our -updateLayer method to be invoked, so we can update our appearance to reflect the new selected.
        [ self setNeedsDisplay: YES ];
        }
    }

- ( BOOL ) isSelected
    {
    return isSelected_;
    }

@synthesize highlightState = highlightState_;
- ( void ) setHighlightState: ( NSCollectionViewItemHighlightState )_NewState
    {
    if ( highlightState_ != _NewState )
        {
        highlightState_ = _NewState;

        // Cause our -updateLayer method to be invoked, so we can update our appearance to reflect the new state.
        [ self setNeedsDisplay: YES ];
        }
    }

- ( NSCollectionViewItemHighlightState ) highlightState
    {
    return highlightState_;
    }

#pragma mark - Private

@synthesize subLayer_ = priSubLayer_;
- ( TauContentCollectionItemSubLayer* ) subLayer_
    {
    if ( !priSubLayer_ )
        {
        CALayer* superlayer = self.layer;
        priSubLayer_ = [ [ TauContentCollectionItemSubLayer alloc ] init ];
        [ superlayer addSublayer: priSubLayer_ ];

        if ( !superlayer.layoutManager )
            [ superlayer setLayoutManager: [ CAConstraintLayoutManager layoutManager ] ];

        NSString* superlayerName = @"superlayer";
        [ priSubLayer_ addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidX relativeTo: superlayerName attribute: kCAConstraintMidX ] ];
        [ priSubLayer_ addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintMidY relativeTo: superlayerName attribute: kCAConstraintMidY ] ];
        [ priSubLayer_ addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintWidth relativeTo: superlayerName attribute: kCAConstraintWidth offset: -10.f ] ];
        [ priSubLayer_ addConstraint: [ CAConstraint constraintWithAttribute: kCAConstraintHeight relativeTo: superlayerName attribute: kCAConstraintHeight offset: -10.f ] ];
        }

    return priSubLayer_;
    }

@synthesize borderView_ = priBorderView_;
- ( _PriItemBorderView* ) borderView_
    {
    if ( !priBorderView_ )
        priBorderView_ = [ [ _PriItemBorderView alloc ] initWithFrame: self.bounds ];
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
    self.layerContentsPlacement = NSViewLayerContentsPlacementScaleProportionallyToFill;

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

            priThumbnailImage_ = replacement;
            [ self updateUI_ ];
            return;
            }

        priThumbnailImage_ = nil;
        [ self updateUI_ ];
        [ [ TauYTDataService sharedService ] fetchPreferredThumbnailFrom: thumbnailDetails
                                                                 success:
        ^( NSImage* _Image, GTLYouTubeThumbnailDetails* _ThumbnailDetails, BOOL _LoadsFromCache )
            {
            if ( _ThumbnailDetails == [ self.ytContent valueForKeyPath: @"snippet.thumbnails" ] )
                {
                priThumbnailImage_ = _Image;
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



// ------------------------------------------------------------------------------------------------------------ //



// _PriItemBorderView class
@implementation _PriItemBorderView

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        {
        [ [ self configureForAutoLayout ] setWantsLayer: YES ];
        [ self setLayerContentsRedrawPolicy: NSViewLayerContentsRedrawOnSetNeedsDisplay ];
        }
    return self;
    }

- ( BOOL ) wantsUpdateLayer
    {
    return YES;
    }

- ( void ) updateLayer
    {
    CALayer* layer = self.layer;
    layer.borderWidth = 3.f;
    layer.cornerRadius = 5.f;
    layer.borderColor = ( borderColor_ ? borderColor_ : [ NSColor keyboardFocusIndicatorColor ] ).CGColor;
    }

#pragma mark - External Properties

@synthesize borderColor = borderColor_;
- ( void ) setBorderColor: ( NSColor* )_NewColor
    {
    if ( borderColor_ != _NewColor )
        {
        borderColor_ = _NewColor;
        [ self setNeedsDisplay: YES ];
        }
    }

- ( NSColor* ) borderColor
    {
    return borderColor_;
    }

@end // _PriItemBorderView class