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

// PriItemFocusRing_ class
@interface PriItemFocusRing_ : NSView

#pragma mark - External Properties

@property ( strong, readwrite ) NSColor* borderColor;

@end // PriItemFocusRing_ class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauContentCollectionItemView ()

@property ( strong, readwrite ) NSImage* coverImage_;

// Sub Content Background Layer

@property ( strong, readonly ) TauContentCollectionItemSubLayer* subContentBgLayer_;

@property ( strong, readonly ) NSArray <CAConstraint*>* subContentBgLayerConstraints_;
@property ( strong, readonly ) NSArray <CAConstraint*>* videoItemLayerConstraints_;
@property ( strong, readonly ) NSArray <CAConstraint*>* channelItemLayerConstraints_;

// Focus Ring

@property ( strong, readonly ) PriItemFocusRing_* focusRing_;

// Init

- ( void ) doInit_;

// Content

- ( void ) redrawWithYouTubeContent_;

@end // Private

// TauContentCollectionItemView class
@implementation TauContentCollectionItemView
    {
@protected
    // Layout constraints caches
    NSArray <NSLayoutConstraint*> __strong* priBorderViewPinEdgesCache_;
    }

TauDeallocBegin
TauDeallocEnd

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

#pragma mark - Drawing

- ( void ) updateLayer
    {
    switch ( self.type )
        {
        case TauYouTubeVideo:
        case TauYouTubePlayList:
        case TauYouTubeChannel:
            self.subContentBgLayer_.contents = coverImage_; break;

        default:
            self.subContentBgLayer_.contents = nil; break;
        }

    if ( isSelected_ || ( highlightState_ == NSCollectionViewItemHighlightForSelection ) )
        {
        PriItemFocusRing_* borderView = self.focusRing_;
        [ borderView setBorderColor: isSelected_ ? nil : [ NSColor lightGrayColor ] ];

        [ self addSubview: borderView ];

        if ( YouTubeContent_.tauContentType == TauYouTubeChannel )
            priBorderViewPinEdgesCache_ = [ borderView autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero excludingEdge: ALEdgeLeading ];
        else
            priBorderViewPinEdgesCache_ = [ borderView autoPinEdgesToSuperviewEdges ];
        }
    else
        {
        if ( priBorderViewPinEdgesCache_ && priBorderViewPinEdgesCache_.count > 0 )
            [ self removeConstraints: priBorderViewPinEdgesCache_ ];

        if ( priFocusRing_ )
            [ priFocusRing_ removeFromSuperview ];
        }
    }

- ( BOOL ) wantsUpdateLayer
    {
    return YES;
    }

#pragma mark - Properties

@synthesize YouTubeContent = YouTubeContent_;
@dynamic type;

- ( void ) setYouTubeContent: ( GTLObject* )_New
    {
    if ( YouTubeContent_ != _New )
        {
        YouTubeContent_ = _New;
        [ self redrawWithYouTubeContent_ ];
        }
    }

- ( GTLObject* ) YouTubeContent
    {
    return YouTubeContent_;
    }

- ( TauYouTubeContentType ) type
    {
    return YouTubeContent_.tauContentType;
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

@synthesize coverImage_;
- ( void ) setCoverImage_: ( NSImage* )_New
    {
    // Omitted the self-assignment determination

    coverImage_ = _New;
    [ self setNeedsDisplay: YES ];
    }

- ( NSImage* ) coverImage_
    {
    return coverImage_;
    }

// Sub Content Background Layer

@synthesize subContentBgLayer_ = priSubContentBgLayer_;
- ( TauContentCollectionItemSubLayer* ) subContentBgLayer_
    {
    if ( !priSubContentBgLayer_ )
        {
        CALayer* superlayer = self.layer;
        priSubContentBgLayer_ = [ [ TauContentCollectionItemSubLayer alloc ] init ];
        [ superlayer addSublayer: priSubContentBgLayer_ ];

        if ( !superlayer.layoutManager )
            [ superlayer setLayoutManager: [ CAConstraintLayoutManager layoutManager ] ];
        }

    return [ priSubContentBgLayer_ replaceAllConstraintsWithConstraints: self.subContentBgLayerConstraints_ ];
    }

@dynamic subContentBgLayerConstraints_;
- ( NSArray <CAConstraint*>* ) subContentBgLayerConstraints_
    {
    switch ( self.YouTubeContent.tauContentType )
        {
        case TauYouTubeVideo:
        case TauYouTubePlayList:
            return self.videoItemLayerConstraints_;

        case TauYouTubeChannel:
            return self.channelItemLayerConstraints_;

        case TauYouTubeUnknownContent:
            DDLogUnexpected( @"Unkown content type {%@}", self.YouTubeContent );
            return nil;
        }
    }

NSString static* const sSuperlayerName = @"superlayer";
CGFloat  static  const sSublayerOffset = -10.f;

@synthesize videoItemLayerConstraints_ = priVideoItemLayerConstraints_;
- ( NSArray <CAConstraint*>* ) videoItemLayerConstraints_
    {
    if ( !priVideoItemLayerConstraints_ )
        {
        priVideoItemLayerConstraints_ =
            @[ [ CAConstraint constraintWithAttribute: kCAConstraintMidX relativeTo: sSuperlayerName attribute: kCAConstraintMidX ]
             , [ CAConstraint constraintWithAttribute: kCAConstraintMidY relativeTo: sSuperlayerName attribute: kCAConstraintMidY ]
             , [ CAConstraint constraintWithAttribute: kCAConstraintWidth relativeTo: sSuperlayerName attribute: kCAConstraintWidth offset: sSublayerOffset ]
             , [ CAConstraint constraintWithAttribute: kCAConstraintHeight relativeTo: sSuperlayerName attribute: kCAConstraintHeight offset: sSublayerOffset ]
             ];
        }

    return priVideoItemLayerConstraints_;
    }

@synthesize channelItemLayerConstraints_ = priChannelItemLayerConstraints_;
- ( NSArray <CAConstraint*>* ) channelItemLayerConstraints_
    {
    if ( !priChannelItemLayerConstraints_ )
        {
        priChannelItemLayerConstraints_ =
            @[ [ CAConstraint constraintWithAttribute: kCAConstraintMaxX relativeTo: sSuperlayerName attribute: kCAConstraintMaxX offset: ( sSublayerOffset / 2.f ) ]
             , [ CAConstraint constraintWithAttribute: kCAConstraintMidY relativeTo: sSuperlayerName attribute: kCAConstraintMidY ]
             , [ CAConstraint constraintWithAttribute: kCAConstraintHeight relativeTo: sSuperlayerName attribute: kCAConstraintHeight offset: sSublayerOffset ]
             , [ CAConstraint constraintWithAttribute: kCAConstraintWidth relativeTo: sSuperlayerName attribute: kCAConstraintHeight ]
             ];
        }

    return priChannelItemLayerConstraints_;
    }

@synthesize focusRing_ = priFocusRing_;
- ( PriItemFocusRing_* ) focusRing_
    {
    if ( !priFocusRing_ )
        priFocusRing_ = [ [ [ PriItemFocusRing_ alloc ] initWithFrame: NSZeroRect ] configureForAutoLayout ];

    [ priFocusRing_ setFrame: NSZeroRect ];
    [ priFocusRing_ removeFromSuperview ];
    [ priFocusRing_ removeConstraints: priFocusRing_.constraints ];

    if ( YouTubeContent_.tauContentType == TauYouTubeChannel )
        [ priFocusRing_ autoMatchDimension: ALDimensionWidth toDimension: ALDimensionHeight ofView: priFocusRing_ withOffset: ABS( sSublayerOffset ) ];

    return priFocusRing_;
    }

// Init

- ( void ) doInit_
    {
    [ self configureForAutoLayout ].wantsLayer = YES;

    self.layer.masksToBounds = YES;
    self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawOnSetNeedsDisplay;
    self.layerContentsPlacement = NSViewLayerContentsPlacementScaleProportionallyToFill;

    NSTrackingArea* mouseEventTrackingArea = [ [ NSTrackingArea alloc ] initWithRect: self.bounds options: NSTrackingMouseEnteredAndExited | NSTrackingActiveInActiveApp | NSTrackingInVisibleRect owner: self userInfo: nil ];
    [ self addTrackingArea: mouseEventTrackingArea ];
    }

// Content

- ( void ) redrawWithYouTubeContent_
    {
    GTLYouTubeThumbnailDetails* thumbnailDetails = nil;
    @try {
    thumbnailDetails = [ self.YouTubeContent valueForKeyPath: @"snippet.thumbnails" ];
    } @catch ( NSException* _Ex )
        {
        DDLogFatal( @"%@", _Ex );
        }

    if ( !thumbnailDetails )
        {
        NSSize imageSize = self.bounds.size;
        NSImage* replacement = [ NSImage imageWithSize: imageSize flipped: NO drawingHandler:
        ^BOOL ( NSRect _DstRect )
            {
            [ [ NSColor blackColor ] set ];
            NSRectFill( _DstRect );

            NSString* noCover = NSLocalizedString( @"NO COVER", @"Text displays when there's no cover image for a YouTube content item" );
            NSDictionary* attrs = @{ NSForegroundColorAttributeName : [ NSColor whiteColor ]
                                   , NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue" size: 17 ]
                                   };

            NSSize size = [ noCover sizeWithAttributes: attrs ];
            [ noCover drawAtPoint: NSMakePoint( ( NSWidth( _DstRect ) * .6f - size.width ) / 2, ( NSHeight( _DstRect ) - size.height ) / 2 ) withAttributes: attrs ];

            return YES;
            } ];

        self.coverImage_ = replacement;
        return;
        }

    self.coverImage_ = nil;
    [ [ TauYTDataService sharedService ] fetchPreferredThumbnailFrom: thumbnailDetails
                                                             success:
    ^( NSImage* _Image, GTLYouTubeThumbnailDetails* _ThumbnailDetails, BOOL _LoadsFromCache )
        {
        if ( _ThumbnailDetails == [ self.YouTubeContent valueForKeyPath: @"snippet.thumbnails" ] )
            self.coverImage_ = _Image;

        } failure:
            ^( NSError* _Error )
                {
                DDLogFatal( @"%@", _Error );
                } ];
    }

@end // TauContentCollectionItemView class



// ------------------------------------------------------------------------------------------------------------ //



// PriItemFocusRing_ class
@implementation PriItemFocusRing_
    {
    LRNotificationObserver __strong* appWillBecomeActObserv_;
    LRNotificationObserver __strong* appWillResignActObserv_;
    }

//TauDeallocBegin
//TauDeallocEnd

#pragma mark - Initializations

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        {
        [ [ self configureForAutoLayout ] setWantsLayer: YES ];
        [ self setLayerContentsRedrawPolicy: NSViewLayerContentsRedrawOnSetNeedsDisplay ];
        }

    return self;
    }

#pragma mark - Managing the View Hierarchy

- ( void ) viewWillMoveToSuperview: ( NSView* )_NewSuperview
    {
    if ( _NewSuperview )
        {
        void ( ^_AppActivityNotifBlock )() = ^( NSNotification* _Notif ) { [ self setNeedsDisplay: YES ]; };
        appWillBecomeActObserv_ = [ LRNotificationObserver observerForName: NSApplicationWillBecomeActiveNotification block: _AppActivityNotifBlock ];
        appWillResignActObserv_ = [ LRNotificationObserver observerForName: NSApplicationWillResignActiveNotification block: _AppActivityNotifBlock ];
        }
    else
        {
        appWillBecomeActObserv_ = nil;
        appWillResignActObserv_ = nil;
        }
    }

#pragma mark - Drawing

- ( BOOL ) wantsUpdateLayer
    {
    return YES;
    }

- ( void ) updateLayer
    {
    CALayer* layer = self.layer;
    layer.borderWidth = 3.f;
    layer.cornerRadius = 5.f;

    if ( NSApp.active )
        layer.borderColor = ( borderColor_ ? borderColor_ : [ NSColor keyboardFocusIndicatorColor ] ).CGColor;
    else
        layer.borderColor = [ NSColor lightGrayColor ].CGColor;
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

@end // PriItemFocusRing_ class