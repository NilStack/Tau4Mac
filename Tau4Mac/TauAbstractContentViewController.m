//
//  TauAbstractContentViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractContentViewController.h"

@interface TauAbstractContentViewController ()

@end

@implementation TauAbstractContentViewController

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    [ self.view configureForAutoLayout ];
    [ self.view autoSetDimension: ALDimensionWidth toSize: TAU_APP_MIN_WIDTH relation: NSLayoutRelationGreaterThanOrEqual ];
    [ self.view autoSetDimension: ALDimensionHeight toSize: TAU_APP_MIN_HEIGHT relation: NSLayoutRelationGreaterThanOrEqual ];
    }

@end
