//
//  TestsTauMediaService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TestsTauMediaService : XCTestCase

@end

@implementation TestsTauMediaService
    {
    MediaServiceFetchingUnit_ __strong* mediaServFetchingUnit_;
    }

- (void)setUp {
    [super setUp];

    mediaServFetchingUnit_ = [ [ MediaServiceFetchingUnit_ alloc ] init ];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- ( void ) testMediaServiceFetchingUnit_pos0
    {
    XCTestExpectation* expec = [ self expectationWithDescription: @"expec" ];

    NSURL* url = [ NSURL URLWithString: @"https://yt3.ggpht.com/-sp0YiR_yyR0/AAAAAAAAAAI/AAAAAAAAAAA/kXU4u1ny2T4/s240-c-k-no/photo.jpg" ];
    [ mediaServFetchingUnit_ fetchImageWithURL: url
                                       success:
    ^( NSImage*_Image )
        {
        DDLogExpecting( @"%@", _Image );
        } failure:
            ^( NSError* _Error )
                {
                DDLogRecoverable( @"%@", _Error );
                } ];

    [ mediaServFetchingUnit_ fetchImageWithURL: url
                                       success:
    ^( NSImage*_Image )
        {
        DDLogExpecting( @"%@", _Image );
        } failure:
            ^( NSError* _Error )
                {
                DDLogRecoverable( @"%@", _Error );
                } ];

    [ mediaServFetchingUnit_ fetchImageWithURL: url
                                       success:
    ^( NSImage*_Image )
        {
        DDLogExpecting( @"%@", _Image );
        } failure:
            ^( NSError* _Error )
                {
                DDLogRecoverable( @"%@", _Error );
                } ];
    }

@end
