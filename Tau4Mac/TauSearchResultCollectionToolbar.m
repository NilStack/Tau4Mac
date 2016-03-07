//
//  TauSearchResultCollectionToolbar.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchResultCollectionToolbar.h"
#import "TauSearchResultCollectionPanelTitleView.h"

// Private Interfaces
@interface TauSearchResultCollectionToolbar ()
- ( void ) doInit_;
@end // Private Interfaces

@implementation TauSearchResultCollectionToolbar
    {
    NSUInteger pageNumber_;
    GTLCollectionObject* ytCollectionObject_;

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

- ( void ) setYtCollectionObject: ( GTLCollectionObject* )_NewCollectionObject
    {
    if ( ytCollectionObject_ != _NewCollectionObject )
        {
        ytCollectionObject_ = _NewCollectionObject;
        self.titleView.numberOfResults = [ ( GTLYouTubePageInfo* )[ ytCollectionObject_ performSelector: @selector( pageInfo ) ] totalResults ].integerValue;

        [ self.segPager setEnabled: ( [ ytCollectionObject_ performSelector: @selector( prevPageToken ) ] != nil ) forSegment: 0 ];
        [ self.segPager setEnabled: ( [ ytCollectionObject_ performSelector: @selector( nextPageToken ) ] != nil ) forSegment: 1 ];
        }
    }

- ( GTLCollectionObject* ) ytCollectionObject
    {
    return ytCollectionObject_;
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
