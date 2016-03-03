//
//  TauTTYLogFormatter.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauTTYLogFormatter.h"

// TauTTYLogFormatter class
@implementation TauTTYLogFormatter

#pragma mark - Conforms to <DDLogFormatter>

- ( NSString* ) formatLogMessage: ( DDLogMessage* )_LogMsg
    {
    NSString* logLevel = nil;

    switch ( _LogMsg.flag )
        {
        case DDLogFlagError:   logLevel = @"ERROR";            break;
        case DDLogFlagWarning: logLevel = @"WARNING";          break;
        case DDLogFlagDebug:   logLevel = @"DEBUG";            break;
        case DDLogFlagInfo:    logLevel = @"INFO";             break;
        case DDLogFlagVerbose: logLevel = @"VVVVVVVERBOSE";    break;
        }

    return [ NSString stringWithFormat: @">>>> %@ (%@) `%@`\n%@, L%lu (%@)\n\n\n"
           , logLevel
           , _LogMsg.timestamp
           , _LogMsg.message
           , _LogMsg.function
           , _LogMsg.line
           , _LogMsg.file
           ];
    }

@end // TauTTYLogFormatter class