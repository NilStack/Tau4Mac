//
//  TauContentCollectionItemView.m
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionItemView.h"

@implementation TauContentCollectionItemView

- ( void ) drawRect: ( NSRect )_DirtyRect
    {
    [ super drawRect: dirtyRect ];
    
    [ [ NSColor orangeColor ] set ];
    NSRectFill( _DirtyRect );

    [ [ NSColor blackColor ] set ];
    NSFrameRect( _DirtyRect );
    }

@end
