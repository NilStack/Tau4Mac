//
//  TauTestCase.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauTestCase class
@interface TauTestCase : XCTestCase

#define TAU_UNITTEST_SAMPLES_COUNT 15

#pragma mark - Testing

+ ( BOOL ) isTestMethodPositive: ( SEL )_TestMethodSel;
+ ( BOOL ) isTestMethodNegative: ( SEL )_TestMethodSel;

@end // TauTestCase class