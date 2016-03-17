//
//  TauMainContentView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainContentView.h"

// Private
@interface TauMainContentView ()

- ( void ) doMainContentViewInit_;

@end // Private

// TauMainContentView class
@implementation TauMainContentView

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        [ self doMainContentViewInit_ ];
    return self;
    }

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        [ self doMainContentViewInit_ ];
    return self;
    }

- ( void ) doMainContentViewInit_
    {
    [ self configureForAutoLayout ];
    [ self autoSetDimension: ALDimensionWidth toSize: TAU_APP_MIN_WIDTH relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self autoSetDimension: ALDimensionHeight toSize: TAU_APP_MIN_HEIGHT relation: NSLayoutRelationGreaterThanOrEqual ];
    }

@end // TauMainContentView class