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

#define DDLogFlagFatal       ( 1 << 0 )  // 0000 0000 0001
#define DDLogFlagRecoverable ( 1 << 1 )  // 0000 0000 0010
#define DDLogFlagUnexpected  ( 1 << 7 )  // 0000 1000 0000
#define DDLogFlagWarning     ( 1 << 2 )  // 0000 0000 0100
#define DDLogFlagNotice      ( 1 << 3 )  // 0000 0000 1000
#define DDLogFlagInfo        ( 1 << 4 )  // 0000 0001 0000
#define DDLogFlagDebug       ( 1 << 5 )  // 0000 0010 0000
#define DDLogFlagVerbose     ( 1 << 6 )  // 0000 0100 0000

#define DDLogLevelFatal       ( DDLogFlagFatal )                                        // 0000 0000 0001
#define DDLogLevelRecoverable ( DDLogFlagRecoverable | DDLogLevelFatal )               // 0000 0000 0011
#define DDLogLevelUnexpected  ( DDLogFlagUnexpected | DDLogFlagRecoverable )
#define DDLogLevelWarn        ( DDLogFlagWarning | DDLogFlagUnexpected )                  // 0000 0000 0111
#define DDLogLevelNotice      ( DDLogFlagNotice | DDLogLevelWarn  )                     // 0000 0000 1111
#define DDLogLevelInfo        ( DDLogFlagInfo | DDLogLevelNotice)                     // 0000 0001 1111
#define DDLogLevelDebug       ( DDLogFlagDebug | DDLogLevelInfo  )                     // 0000 0011 1111
#define DDLogLevelVerbose     ( DDLogFlagVerbose | DDLogFlagDebug )  // 0000 0111 1111

#define DDLogFatal( frmt, ... )       LOG_MAYBE( NO,                LOG_LEVEL_DEF, DDLogFlagFatal, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogRecoverable( frmt, ... ) LOG_MAYBE( NO,                LOG_LEVEL_DEF, DDLogFlagRecoverable, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogUnexpected( frmt, ... )  LOG_MAYBE( NO,                LOG_LEVEL_DEF, DDLogFlagUnexpected, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogWarn( frmt, ... )        LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogNotice( frmt, ... )      LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagNotice, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogInfo( frmt, ... )        LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogDebug( frmt, ... )       LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogVerbose( frmt, ... )     LOG_MAYBE( LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )

#define DDLogFatalToDDLog( ddlog, frmt, ... )       LOG_MAYBE_TO_DDLOG( ddlog, NO,                LOG_LEVEL_DEF, DDLogFlagFatal, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogRecoverableToDDLog( ddlog, frmt, ... ) LOG_MAYBE_TO_DDLOG( ddlog, NO,                LOG_LEVEL_DEF, DDLogFlagRecoverable, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogUnexpectedToDDLog( ddlog, frmt, ... )  LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagUnexpected, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogWarnToDDLog( ddlog, frmt, ... )        LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogNoticeToDDLog( ddlog, frmt, ... )      LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagNotice, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogInfoToDDLog( ddlog, frmt, ... )        LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagInfo, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogDebugToDDLog( ddlog, frmt, ... )       LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagDebug, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define DDLogVerboseToDDLog( ddlog, frmt, ... )     LOG_MAYBE_TO_DDLOG( ddlog, LOG_ASYNC_ENABLED, LOG_LEVEL_DEF, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )

#endif /* XCDLog_h */