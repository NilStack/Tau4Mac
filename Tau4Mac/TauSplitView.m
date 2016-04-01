//
//  TauSplitView.m
//  Tau4Mac
//
//  Created by Tong G. on 4/1/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSplitView.h"

// TauSplitView class
@implementation TauSplitView

- ( instancetype ) initWithFrame: ( NSRect )_FrameRect
    {
    if ( self = [ super initWithFrame: _FrameRect ] )
        self.dividerStyle = NSSplitViewDividerStyleThin;

    return self;
    }

- ( NSColor* ) dividerColor
    {
    return [ [ NSColor lightGrayColor ] colorWithAlphaComponent: .7f ];
    }

@end // TauSplitView class