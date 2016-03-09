//
//  TauAbstractYouTubeBadge.m
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractYouTubeBadge.h"
#import "PriTauBadgeTextInternalCell_.h"

// TauAbstractYouTubeBadge class
@implementation TauAbstractYouTubeBadge
    {
    PriTauBadgeTextInternalCell_ __strong* internalView_;
    GTLObject __strong* ytContent_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        {
        [ self configureForAutoLayout ];
        [ self autoSetDimensionsToSize: NSMakeSize( 65.f, 16.f ) ];
        }

    return self;
    }

#pragma mark - Drawing

+ ( Class ) cellClass
    {
    return [ PriTauBadgeTextInternalCell_ class ];
    }

#pragma mark - Dynamic Properties

@dynamic ytContent;

- ( void ) setYtContent: ( GTLObject* )_New
    {
    if ( ytContent_ != _New )
        ytContent_ = _New;
    }

- ( GTLObject* ) ytContent
    {
    return ytContent_;
    }

@end // TauAbstractYouTubeBadge class

// PriTauBadgeTextInternalCell_ class
@implementation PriTauBadgeTextInternalCell_
    {
    NSDictionary __strong* drawingAttrs_;
    }

#pragma mark - Drawing

- ( void ) drawWithFrame: ( NSRect )_DirtyRect inView: ( NSView* )_ControlView
    {
    if ( !drawingAttrs_ )
        {
        drawingAttrs_ = @{ NSForegroundColorAttributeName : [ NSColor whiteColor ]
                         , NSFontAttributeName : [ NSFont fontWithName: @"Helvetica Neue" size: 12 ]
                         };
        }

    [ [ NSColor colorWithSRGBRed: 81.f / 255 green: 81.f / 255 blue: 81.f / 255 alpha: 1.f ] set ];
    NSRectFill( _ControlView.bounds );

    NSString* badgeText = self.badgeText;
    NSSize badgeTextSize = [ badgeText sizeWithAttributes: drawingAttrs_ ];
    [ badgeText drawAtPoint: NSMakePoint( ( NSWidth( _ControlView.bounds ) - badgeTextSize.width ) / 2
                                        , ( NSHeight( _ControlView.bounds ) - badgeTextSize.height ) / 2 + 1.5f )
             withAttributes: drawingAttrs_ ];
    }

@end // PriTauBadgeTextInternalCell_ class