//
//  TauDataServiceConsumer.m
//  Tau4Mac
//
//  Created by Tong G. on 3/11/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "NSObject+TauDataServiceConsumer.h"

// NSObject + TauDataServiceConsumer
@implementation NSObject ( TauDataServiceConsumer )

@dynamic ytContent;

void* const kYTContent = @"kYTContent";

- ( void ) setYtContent: ( GTLObject* )_New
    {
    objc_setAssociatedObject( self, kYTContent, _New, OBJC_ASSOCIATION_RETAIN );
    }

- ( GTLObject* ) ytContent
    {
    return objc_getAssociatedObject( self, kYTContent );
    }

@end // NSObject + TauDataServiceConsumer