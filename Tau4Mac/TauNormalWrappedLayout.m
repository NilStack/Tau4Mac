/*
    Copyright (C) 2015 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    This is the "WrappedLayout" class implementation.
*/

#import "TauNormalWrappedLayout.h"

// TauNormalWrappedLayout class
@implementation TauNormalWrappedLayout

#pragma mark - Overrides

- ( instancetype ) init
    {
    self = [ super init ];

    if ( self )
        {
        [ self setItemSize: NSMakeSize( TauNormalWrappedLayoutItemWidth, TauNormalWrappedLayoutItemHeight ) ];
        [ self setMinimumInteritemSpacing: TauNormalWrappedLayoutXPadding ];
        [ self setMinimumLineSpacing: TauNormalWrappedLayoutYPadding ];

        [ self setSectionInset: NSEdgeInsetsMake( TauNormalWrappedLayoutYPadding, TauNormalWrappedLayoutXPadding
                                                , TauNormalWrappedLayoutYPadding, TauNormalWrappedLayoutXPadding
                                                ) ];
        }

    return self;
    }

- ( NSCollectionViewLayoutAttributes* ) layoutAttributesForItemAtIndexPath: ( NSIndexPath* )_IndexPath
    {
    NSCollectionViewLayoutAttributes* attributes = [ super layoutAttributesForItemAtIndexPath: _IndexPath ];
    [ attributes setZIndex: [ _IndexPath item ] ];
    return attributes;
    }

- ( NSArray* ) layoutAttributesForElementsInRect: ( NSRect )_Rect
    {
    NSArray* layoutAttributesArray = [ super layoutAttributesForElementsInRect: _Rect ];
    for ( NSCollectionViewLayoutAttributes* _Attributes in layoutAttributesArray )
        [ _Attributes setZIndex: [ [ _Attributes indexPath ] item ] ];

    return layoutAttributesArray;
    }

@end // TauNormalWrappedLayout class