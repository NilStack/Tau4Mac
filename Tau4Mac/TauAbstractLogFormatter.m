//
//  TauAbstractLogFormatter.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractLogFormatter.h"

@implementation TauAbstractLogFormatter

#pragma mark - Conforms to <DDLogFormatter>

- ( NSString* ) formatLogMessage: ( DDLogMessage* )_LogMsg
    {
    [ self doesNotRecognizeSelector: _cmd ];
    return nil;
    }

@end
