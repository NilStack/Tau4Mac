//
//  TauBooleanStatusBadge.m
//  Tau4Mac
//
//  Created by Tong G. on 5/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauBooleanStatusBadge.h"

// TauBooleanStatusBadge class
@implementation TauBooleanStatusBadge

- ( instancetype ) initWithCoder: ( NSCoder* )_Coder
    {
    if ( self = [ super initWithCoder: _Coder ] )
        {
        booleanStatus_ = NO;
        self.image = [ NSImage imageNamed: NSImageNameStatusUnavailable ];
        }

    return self;
    }

@synthesize booleanStatus = booleanStatus_;
+ ( BOOL ) automaticallyNotifiesObserversOfBooleanStatus
    {
    return NO;
    }

- ( void ) setBooleanStatus: ( BOOL )_New
    {
    if ( booleanStatus_ != _New )
        {
        [ self willChangeValueForKey: TauKVOStrictClassKeyPath( TauBooleanStatusBadge, booleanStatus ) ];
        booleanStatus_ = _New;
        self.image = [ NSImage imageNamed: booleanStatus_ ? NSImageNameStatusAvailable : NSImageNameStatusUnavailable ];
        [ self didChangeValueForKey: TauKVOStrictClassKeyPath( TauBooleanStatusBadge, booleanStatus ) ];
        }
    }

- ( BOOL ) booleanStatus
    {
    return booleanStatus_;
    }

@end // TauBooleanStatusBadge class