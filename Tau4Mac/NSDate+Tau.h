//
//  NSDate+Tau.h
//  Tau4Mac
//
//  Created by Tong G. on 5/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// NSDate + Tau
@interface NSDate ( Tau )

#pragma mark - Getting Time Intervals

+ ( NSTimeInterval ) timeIntervalFromISO8601Duration: ( NSString* )_ISO8601Duration;

@end // NSDate + Tau