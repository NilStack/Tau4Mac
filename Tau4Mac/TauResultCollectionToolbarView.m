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

#pragma mark - Dynamic Properties

@dynamic pageNumber;

- ( void ) setPageNumber: ( NSUInteger )_NewNumber
    {
    if ( pageNumber_ != _NewNumber )
        {
        pageNumber_ = _NewNumber;

        self.segPager.segmentCount = pageNumber_ + 2;
        for ( int _SegIndex = 0; _SegIndex < self.segPager.segmentCount; _SegIndex++ )
            {
            [ self.segPager setWidth: 30.f forSegment: _SegIndex ];

            if ( _SegIndex == 0 )
                {
                [ self.segPager setImage: [ NSImage imageNamed: @"NSGoLeftTemplate" ] forSegment: _SegIndex ];
                [ self.segPager setLabel: @"" forSegment: _SegIndex ];
                }
            else if ( _SegIndex == self.segPager.segmentCount - 1 )
                {
                [ self.segPager setImage: [ NSImage imageNamed: @"NSGoRightTemplate" ] forSegment: _SegIndex ];
                [ self.segPager setLabel: @"" forSegment: _SegIndex ];
                }
            else
                {
                [ self.segPager setLabel: @( _SegIndex ).stringValue forSegment: _SegIndex ];
                [ self.segPager setImage: nil forSegment: _SegIndex ];
                }
            }

        [ self layout_ ];
        }
    }

- ( void ) layout_
    {
    if ( layoutConstraintsCache_ )
        {
        [ self.segPager removeFromSuperview ];
        [ self.title removeFromSuperview ];
        [ self.dismissButton removeFromSuperview ];

        [ self removeConstraints: layoutConstraintsCache_ ];
        }

    [ self addSubview: self.segPager ];
    layoutConstraintsCache_ = @[ [ self.segPager autoPinEdge: ALEdgeTop toEdge: ALEdgeTop ofView: self ] ];
    }

- ( NSUInteger ) pageNumber
    {
    return pageNumber_;
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
