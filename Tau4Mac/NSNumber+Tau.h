//
//  NSNumber+Tau.h
//  Tau4Mac
//
//  Created by Tong G. on 3/31/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// NSNumber + Tau
@interface NSNumber ( Tau )

#pragma mark - Creating an NSNumber Object

+ ( instancetype ) numberWithNegateBool: ( BOOL )_Flag;

#pragma mark - YouTube Contents

@property ( copy, readonly ) NSString* youtubeCategoryName;

@end // NSNumber + Tau