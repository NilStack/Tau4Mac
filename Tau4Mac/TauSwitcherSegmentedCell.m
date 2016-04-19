#import "TauSwitcherSegmentedCell.h"

// TauSwitcherSegmentedCell class
@implementation TauSwitcherSegmentedCell

#pragma mark - Segmented Cell Methods

// ------------------------------------------------------
/// customize drawing items
- ( void ) drawWithFrame: ( NSRect )_CellFrame inView: ( nonnull NSView* )_ControlView
// ------------------------------------------------------
    {
    // draw only inside
    [ self drawInteriorWithFrame: _CellFrame inView: _ControlView ];
    }

// ------------------------------------------------------
/// draw each segment
- ( void ) drawSegment: ( NSInteger )_Segment inFrame: ( NSRect )_Frame withView: ( nonnull NSSegmentedControl* )_ControlView
// ------------------------------------------------------
    {
    // use another image on selected segment
    //   -> From a universal design point of view, it's better to use an image that has a different silhouette from the normal (unselected) one.
    //      Some of users may hard to distinguish the selected state just by the color.
    if ( [ self isSelectedForSegment: _Segment ] )
        {
        // load "selected" icon template
        NSString* iconName = [ [ self imageForSegment: _Segment ] name ];
        NSImage* selectedIcon = [ NSImage imageNamed: [ @"selected-" stringByAppendingString: iconName ] ];
        
        // calculate area to draw
        NSRect imageRect = [ self imageRectForBounds: _Frame ];
        imageRect.origin.y += floor( ( imageRect.size.height - [ selectedIcon size ].height ) / 2.f );
        imageRect.size = [ selectedIcon size ];
        
        // draw icon template
        // ( On Mavericks and later, you can use simply `drawInRect:` )
        [ selectedIcon drawInRect: imageRect fromRect: NSZeroRect operation: NSCompositeSourceOver fraction: 1.f respectFlipped: YES hints: @{} ];
        
        // tint drawn icon template
        [ [ NSColor alternateSelectedControlColor ] set ];
        NSRectFillUsingOperation( _Frame, NSCompositeSourceIn );
        } else [ super drawSegment: _Segment inFrame: _Frame withView: _ControlView ];
    }

@end // TauSwitcherSegmentedCell class