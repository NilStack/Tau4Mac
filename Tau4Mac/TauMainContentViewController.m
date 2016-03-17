//
//  TauMainContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainContentViewController.h"

// Private
@interface TauMainContentViewController ()

@end // Private

// TauMainContentViewController class
@implementation TauMainContentViewController

#pragma mark - KVO

- ( void ) selectedSegmentDidChange: ( NSDictionary* )_ChangeDict observing: ( id )_Observing
    {
    NSLog( @"%@", _ChangeDict );
    }

@end // TauMainContentViewController class