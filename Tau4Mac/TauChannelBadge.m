//
//  TauChannelBadge.m
//  Tau4Mac
//
//  Created by Tong G. on 3/6/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauChannelBadge.h"

// BadgeTextInternalView_ class
@interface BadgeTextInternalView_ : NSView

@end // BadgeTextInternalView_ class

// TauChannelBadge class
@implementation TauChannelBadge
    {
    BadgeTextInternalView_ __strong* internalView_;
    }

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        {
        self.blendingMode = NSVisualEffectBlendingModeWithinWindow;
        self.material = NSVisualEffectMaterialLight;
        self.state = NSVisualEffectStateActive;

        [ self configureForAutoLayout ];
        [ self autoSetDimensionsToSize: NSMakeSize( 60, 16 ) ];

        internalView_ = [ [ BadgeTextInternalView_ alloc ] initWithFrame: NSZeroRect ];
        [ self addSubview: internalView_ ];
        [ internalView_ autoPinEdgesToSuperviewEdges ];
        }

    return self;
    }

- ( CALayer* ) makeBackingLayer
    {
    CALayer* backingLayer = [ super makeBackingLayer ];
    backingLayer.cornerRadius = 3.f;

    return backingLayer;
    }

@end // TauChannelBadge class

// BadgeTextInternalView_ class
@implementation BadgeTextInternalView_
    {
    NSDictionary __strong* drawingAttrs_;
    }

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        [ self configureForAutoLayout ];

    return self;
    }

- ( BOOL ) isFlipped
    {
    return YES;
    }

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    if ( !drawingAttrs_ )
        drawingAttrs_ = @{ NSForegroundColorAttributeName : [ NSColor colorWithSRGBRed: 81.f / 255 green: 81.f / 255 blue: 81.f / 255 alpha: 1.f ]
                         , NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue" size: 12 ]
                         };

    NSString* badgeText = NSLocalizedString( @"CHANNEL", nil );
    NSSize badgeTextSize = [ badgeText sizeWithAttributes: drawingAttrs_ ];
    [ badgeText drawAtPoint: NSMakePoint( ( NSWidth( self.bounds ) - badgeTextSize.width ) / 2
                                        , ( NSHeight( self.bounds ) - badgeTextSize.height ) / 2 - 1.5f )
             withAttributes: drawingAttrs_ ];
    }

@end // BadgeTextInternalView_ class