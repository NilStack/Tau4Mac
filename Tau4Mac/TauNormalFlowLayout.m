#import "TauNormalFlowLayout.h"

// TauNormalFlowLayout class
@implementation TauNormalFlowLayout

#pragma mark - Overrides

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        [ self setItemSize: NSMakeSize( TauVideoLayoutItemWidth, TauVideoLayoutItemHeight ) ];
        [ self setMinimumInteritemSpacing: TauNormalFlowLayoutXPadding ];
        [ self setMinimumLineSpacing: TauNormalFlowLayoutYPadding ];

        [ self setSectionInset: NSEdgeInsetsMake(
            TauNormalFlowLayoutYPadding, TauNormalFlowLayoutXPadding, TauNormalFlowLayoutYPadding, TauNormalFlowLayoutXPadding ) ];
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

@end // TauNormalFlowLayout class