//
//  TauContentCollectionItemBorderView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/21/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionItemBorderView.h"
#import "NSColor+TauDrawing.h"

@implementation TauContentCollectionItemBorderView

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
    layer.borderColor = [ NSColor keyboardFocusIndicatorColor ].CGColor;
    layer.borderWidth = 3.f;
//    layer.cornerRadius = 8.f;
    }

@end
