//
//  XCDLog.h
//  XCDYouTubeKitLab
//
//  Created by Tong G. on 3/2/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#ifndef XCDLog_h
#define XCDLog_h

// We want to use the following log levels:
// 
// Fatal
// Error
// Warn
// Notice
// Info
// Debug
// 
// All we have to do is undefine the default values,
// and then simply define our own however we want.

// First undefine the default stuff we don't want to use.

#undef DDLogFlagError
#undef DDLogFlagWarning
#undef DDLogFlagInfo
#undef DDLogFlagDebug
#undef DDLogFlagVerbose

#undef DDLogLevelError
#undef DDLogLevelWarning
#undef DDLogLevelInfo
#undef DDLogLevelDebug
#undef DDLogLevelVerbose

#undef LOG_ERROR
#undef LOG_WARN
#undef LOG_INFO
#undef LOG_DEBUG
#undef LOG_VERBOSE

#undef DDLogError
#undef DDLogWarn
#undef DDLogInfo
#undef DDLogDebug
#undef DDLogVerbose

#undef DDLogErrorToDDLog
#undef DDLogWarnToDDLog
#undef DDLogNoticeToDDLog
#undef DDLogInfoToDDLog
#undef DDLogDebugToDDLog
#undef DDLogVerboseToDDLog

// Now define everything how we want it

#define DDLogFlagFatal        ( 1 << 0 )
#define DDLogFlagRecoverable  ( 1 << 1 )
#define DDLogFlagLocalError   ( 1 << 8 )
#define DDLogFlagNetworkError ( 1 << 9 )
#define DDLogFlagUserError    ( 1 << 10 )
#define DDLogFlagUnexpected   ( 1 << 7 )
#define DDLogFlagWarning      ( 1 << 2 )
#define DDLogFlagNotice       ( 1 << 3 )
#define DDLogFlagInfo         ( 1 << 4 )
#define DDLogFlagDebug        ( 1 << 5 )
#define DDLogFlagVerbose      ( 1 << 6 )

#define DDLogLevelFatal        ( DDLogFlagFatal )
#define DDLogLevelRecoverable  ( DDLogFlagRecoverable | DDLogLevelFatal )
#define DDLogLevelLocalError   ( DDLogLevelRecoverable )    // Local error is essentially recoverable
#define DDLogLevelNetworkError ( DDLogLevelRecoverable )    // Network error is essentially recoverable
#define DDLogLevelUserError    ( DDLogLevelRecoverable )    // User error is essentially recoverable
#define DDLogLevelUnexpected   ( DDLogFlagUnexpected | DDLogFlagRecoverable )
#define DDLogLevelWarn         ( DDLogFlagWarning | DDLogFlagUnexpected )
#define DDLogLevelNotice       ( DDLogFlagNotice | DDLogLevelWarn  )
#define DDLogLevelInfo         ( DDLogFlagInfo | DDLogLevelNotice)
#define DDLogLevelDebug        ( DDLogFlagDebug | DDLogLevelInfo  )
#define DDLogLevelVerbose      ( DDLogFlagVerbose | DDLogFlagDebug )

#define LOG_FATAL         ( ddLogLevel & DDLogFlagFatal )
#define LOG_RECOVERABLE   ( ddLogLevel & DDLogFlagRecoverable )
#define LOG_LOCAL_ERROR   ( ddLogLevel & DDLogFlagRecoverable )
#define LOG_NETWORK_ERROR ( ddLogLevel & DDLogFlagRecoverable )
#define LOG_USER_ERROR    ( ddLogLevel & DDLogFlagRecoverable )
#define LOG_UNEXPECTED    ( ddLogLevel & DDLogFlagUnexpected )
#define LOG_WARN          ( ddLogLevel & DDLogFlagWarning )
#define LOG_NOTICE        ( ddLogLevel & DDLogFlagNotice )
#define LOG_INFO          ( ddLogLevel & DDLogFlagInfo )
#define LOG_DEBUG         ( ddLogLevel & DDLogFlagDebug )
#define LOG_VERBOSE       ( ddLogLevel & DDLogFlagVerbose )

#define DDLogFatal( frmt, ... )        LOG_MAYBE( NO,                LOG_LEVEL_DEF, DDLogFlagFatal, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogRecoverable( frmt, ... )  LOG_MAYBE( NO,                LOG_LEVEL_DEF, DDLogFlagRecoverable, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogLocalError( frmt, ... )   LOG_MAYBE( NO,                LOG_LEVEL_DEF, DDLogFlagLocalError, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogNetworkError( frmt, ... ) LOG_MAYBE( NO,                LOG_LEVEL_DEF, DDLogFlagNetworkError, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogUserError( frmt, ... )    LOG_MAYBE( NO,                LOG_LEVEL_DEF, DDLogFlagUserError, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogUnexpected( frmt, ... )   LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagUnexpected, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogWarn( frmt, ... )         LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogNotice( frmt, ... )       LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagNotice, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogInfo( frmt, ... )         LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogDebug( frmt, ... )        LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogVerbose( frmt, ... )      LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )

#define DDLogFatalToDDLog( ddlog, frmt, ... )        LOG_MAYBE_TO_DDLOG( ddlog, NO,                LOG_LEVEL_DEF, DDLogFlagFatal, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogRecoverableToDDLog( ddlog, frmt, ... )  LOG_MAYBE_TO_DDLOG( ddlog, NO,                LOG_LEVEL_DEF, DDLogFlagRecoverable, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogLocalErrorToDDLog( ddlog, frmt, ... )   LOG_MAYBE_TO_DDLOG( ddlog, NO,                LOG_LEVEL_DEF, DDLogFlagLocalError, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogNetworkErrorToDDLog( ddlog, frmt, ... ) LOG_MAYBE_TO_DDLOG( ddlog, NO,                LOG_LEVEL_DEF, DDLogFlagNetworkError, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogUserErrorToDDLog( ddlog, frmt, ... )    LOG_MAYBE_TO_DDLOG( ddlog, NO,                LOG_LEVEL_DEF, DDLogFlagUserError, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogUnexpectedToDDLog( ddlog, frmt, ... )   LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagUnexpected, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogWarnToDDLog( ddlog, frmt, ... )         LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogNoticeToDDLog( ddlog, frmt, ... )       LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagNotice, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogInfoToDDLog( ddlog, frmt, ... )         LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogDebugToDDLog( ddlog, frmt, ... )        LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogVerboseToDDLog( ddlog, frmt, ... )      LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )

#endif /* XCDLog_h */