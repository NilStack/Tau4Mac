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

    switch ( ( uint64 )( _LogMsg.flag ) )
        {
        case DDLogFlagFatal:       logLevel = @"FATAL"; break;

        case DDLogFlagRecoverable:  logLevel = @"RECOVERABLE_ERROR"; break;
        case DDLogFlagLocalError:   logLevel = @"LOCAL_ERROR";       break;
        case DDLogFlagNetworkError: logLevel = @"NETWORK_ERROR";     break;
        case DDLogFlagUserError:    logLevel = @"USER_ERROR";        break;

        case DDLogFlagUnexpected:   logLevel = @"UNEXPECTED";        break;
        case DDLogFlagWarning:      logLevel = @"WARNING";           break;
        case DDLogFlagNotice:       logLevel = @"NOTICE";            break;

        case DDLogFlagDebug:        logLevel = @"DEBUG";             break;
        case DDLogFlagExpecting:    logLevel = @"EXPECTING";         break;
        case DDLogFlagInfo:         logLevel = @"INFO";              break;
        case DDLogFlagVerbose:      logLevel = @"VVVVVVVERBOSE";     break;

        case TMSLogFlagInitialTrial:
        case TMSLogFlagCreateFetchingUnit:
        case TMSLogFlagEnqueueFetchingUnit:
        case TMSLogFlagFetchingUnitsCount:
        case TMSLogFlagFetchingUnitDiscardable:
            logLevel = @"[tms]";
             return [ NSString stringWithFormat: @">>>> %@%@"
           , logLevel
           , _LogMsg.message ];
        }

    NSString* fileName = TAU_LOG_PATH_OF_FILE( _LogMsg.fileName );

    return [ NSString stringWithFormat: @">>>> %@ (%@) (%@) ~ %@, L:%@ (%@.m)"
           , logLevel
           , _LogMsg.timestamp
           , _LogMsg.message
#if !RELEASE
           , _LogMsg.function , @( _LogMsg.line )
#else
           , @"?[unknown unknown:]", @"unknown"
#endif
           , fileName
           ];
    }

@end // TauTTYLogFormatter class