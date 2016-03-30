//
//  TauContentCollectionItemSubLayer.m
//  Tau4Mac
//
//  Created by Tong G. on 3/4/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionItemSubLayer.h"

// TauContentCollectionItemSubLayer class
@implementation TauContentCollectionItemSubLayer

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        {
        [ self setMasksToBounds: YES ];
        [ self setContentsGravity: kCAGravityResizeAspectFill ];

        [ self setActions: @{ @"contents" : NSNull.null
                            , @"bounds" : NSNull.null
                            , @"position" : NSNull.null
                            } ];
        }

    return self;
    }

@end // TauContentCollectionItemSubLayer class