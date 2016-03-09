//
//  TauMosEnteredInteractionButton.m
//  Tau4Mac
//
//  Created by Tong G. on 3/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMosEnteredInteractionButton.h"
#import "NSBezierPath+TwipokerDrawing.h"

// TauMosEnteredInteractionButton class
@implementation TauMosEnteredInteractionButton

#pragma mark - Drawing

+ ( Class ) cellClass
    {
    return [ TauMosEnteredInteractionButtonCell class ];
    }

@end // TauMosEnteredInteractionButton class

// TauMosEnteredInteractionButtonCell class
@implementation TauMosEnteredInteractionButtonCell

#pragma mark - Drawing

- ( void ) drawWithFrame: ( NSRect )_CellFrame inView: ( NSView* )_ControlView
    {
    CGFloat radius = 10.f;
    NSBezierPath* boundsPath = [ NSBezierPath bezierPathWithRoundedRect: _ControlView.bounds withRadiusOfTopLeftCorner: radius bottomLeftCorner: radius topRightCorner: radius bottomRightCorner: radius isFlipped: NO ];

    [ boundsPath setLineWidth: .5f ];

    if ( self.isHighlighted )
        [ [ NSColor colorWithSRGBRed: 151.f / 255 green: 151.f / 255 blue: 151.f / 255 alpha: .95f ] set ];
    else
        [ [ NSColor colorWithSRGBRed: 72.f / 255 green: 72.f / 255 blue: 72.f / 255 alpha: .95f ] set ];

    [ boundsPath fill ];
    [ boundsPath stroke ];

    NSString* titleText = [ self title ];
    NSDictionary* drawingDict = @{ NSFontAttributeName : self.font
                                 , NSForegroundColorAttributeName : self.isHighlighted ? [ NSColor blackColor ] : [ [ NSColor whiteColor ] colorWithAlphaComponent: .8f ]
                                 };
                                 
    NSSize titleTextSize = [ titleText sizeWithAttributes: drawingDict ];
    [ titleText drawAtPoint: NSMakePoint( ( NSWidth( _ControlView.frame ) - titleTextSize.width ) / 2
                                        , ( NSHeight( _ControlView.frame ) - titleTextSize.height ) / 2 - .5f )
             withAttributes: drawingDict ];
    }

@end // TauMosEnteredInteractionButtonCell class