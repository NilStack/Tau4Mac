//
//  TestsCentralDataServiceMachanism.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYTDataService.h"

// TestsCentralDataServiceMachanism class
@interface TestsCentralDataServiceMachanism : XCTestCase

@end // TestsCentralDataServiceMachanism class

// TestsCentralDataServiceMachanism class
@implementation TestsCentralDataServiceMachanism
    {
    }

- ( void ) setUp
    {
    [ super setUp ];

    TauYTDataService* sharedService = [ TauYTDataService sharedService ];
    NSLog( @"%@", sharedService );
    }

- ( void ) tearDown
    {
    // TODO:
    }

- ( void ) testWhatever
    {

    }

@end // TestsCentralDataServiceMachanism class