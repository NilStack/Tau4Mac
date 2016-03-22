//
//  ViewStackItem.m
//  Tau4Mac
//
//  Created by Tong G. on 3/18/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "ViewStackItem.h"

@interface ViewStackItem ()

@end

@implementation ViewStackItem

- ( NSString* ) description
    {
    return [ NSString stringWithFormat: @"%@ <%p>", self.identifier, self ];
    }

@end
