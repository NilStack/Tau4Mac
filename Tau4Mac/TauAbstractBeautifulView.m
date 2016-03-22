//
//  TauAbstractBeautifulView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/7/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractBeautifulView.h"

// Private Interfaces
@interface TauAbstractBeautifulView ()
- ( void ) doInit_;
@end // Private Interfaces

// TauAbstractBeautifulView class
@implementation TauAbstractBeautifulView

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

#pragma mark - Private Interfaces

- ( void ) doInit_
    {
    self.wantsLayer = YES;
    [ self configureForAutoLayout ];
    }

@end // TauAbstractBeautifulView class