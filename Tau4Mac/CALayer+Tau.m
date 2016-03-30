//
//  CALayer+Tau.m
//  Tau4Mac
//
//  Created by Tong G. on 3/30/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "CALayer+Tau.h"

// CALayer + Tau
@implementation CALayer ( Tau )

#pragma mark - Managing Layer Constraints

- ( void ) addConstraints: ( NSArray <CAConstraint*>* )_Constraints
    {
    for ( CAConstraint* _Elem in _Constraints )
        {
        if ( ![ _Elem isKindOfClass: [ CAConstraint class ]] )
            DDLogUnexpected( @"{%@} is not an instance of CAConstraint", _Elem );
        else
            [ self addConstraint: _Elem ];
        }
    }

- ( void ) removeAllConstraints
    {
    [ self setConstraints: @[] ];
    }

- ( instancetype ) replaceAllConstraintsWithConstraints: ( NSArray <CAConstraint*>* )_Constraints
    {
    [ self removeAllConstraints ];
    [ self addConstraints: _Constraints ];

    return self;
    }

@end // CALayer + Tau