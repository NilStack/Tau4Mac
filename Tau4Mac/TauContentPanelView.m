//
//  TauContentPanelView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentPanelView.h"

// Private Interfaces
@interface TauContentPanelView ()

// Init

- ( void ) doInit_;

@end // Private Interfaces

// TauContentPanelView class
@implementation TauContentPanelView

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

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: _DirtyRect ];
    
    // Drawing code here.
    [ [ NSColor orangeColor ] set];
    NSRectFill( self.bounds );
    }

#pragma mark - Private Interfaces

// Init

- ( void ) doInit_
    {
    [ self configureForAutoLayout ];

    [ self autoSetDimension: ALDimensionWidth toSize: 0.f relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self autoSetDimension: ALDimensionHeight toSize: 0.f relation: NSLayoutRelationGreaterThanOrEqual ];
    }

@end // TauContentPanelView class