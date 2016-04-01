//
//  CALayer+Tau.h
//  Tau4Mac
//
//  Created by Tong G. on 3/30/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// CALayer + Tau
@interface CALayer ( Tau )

#pragma mark - Managing Layer Constraints

- ( void ) addConstraints: ( NSArray <CAConstraint*>* )_Constraints;
- ( void ) removeAllConstraints;
- ( instancetype ) replaceAllConstraintsWithConstraints: ( NSArray <CAConstraint*>* )_Constraints;

@end // CALayer + Tau