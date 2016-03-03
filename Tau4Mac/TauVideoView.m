//
//  TauVideoView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauVideoView.h"

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
        {
        self.wantsLayer = YES;
        self.layer.delegate = self;
        self.layerContentsRedrawPolicy = NSViewLayerContentsRedrawNever;
        self.layerContentsPlacement = NSViewLayerContentsPlacementScaleProportionallyToFit;

        [ self configureForAutoLayout ];
        [ self autoSetDimension: ALDimensionWidth toSize: 120 relation: NSLayoutRelationGreaterThanOrEqual ];
        [ self autoMatchDimension: ALDimensionHeight toDimension: ALDimensionWidth ofView: self withMultiplier: 9.f / 16.f ];
        }

    return self;
    }

#pragma mark - Core Animations

- ( CALayer* ) makeBackingLayer
    {
    return [ [ CALayer alloc ] init ];
    }

- ( void ) displayLayer: ( CALayer* )_Layer
    {
    self.layer.contents = thumbnailImage_;
    }

@end // TauVideoView class