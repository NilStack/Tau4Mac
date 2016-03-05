//
//  TauResultCollectionToolbarView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauResultCollectionToolbarView.h"

// Private Interfaces
@interface TauResultCollectionToolbarView ()
- ( void ) doInit_;
@end // Private Interfaces

@implementation TauResultCollectionToolbarView
    {
    NSUInteger pageNumber_;

    NSArray <NSLayoutConstraint*>* layoutConstraintsCache_;
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

#pragma mark - Private Interfaces

- ( void ) doInit_
    {
    [ self configureForAutoLayout ];

    self.wantsLayer = YES;
    self.blendingMode = NSVisualEffectBlendingModeWithinWindow;
    self.material = NSVisualEffectMaterialDark;
    self.state = NSVisualEffectStateActive;
    }

@end
