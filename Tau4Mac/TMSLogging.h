//
//  XCDLog.h
//  XCDYouTubeKitLab
//
//  Created by Tong G. on 3/2/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#ifndef TMSLogging_h
#define TMSLogging_h

// Flags
#define TMSLogFlagInitialTrial            ( DDLogFlagVerbose << 1 ) // Emoji: Watermelon (\U0001F349)
#define TMSLogFlagCreateFetchingUnit      ( DDLogFlagVerbose << 2 ) // Emoji: Speak-No-Evil Monkey (\U0001F64A)
#define TMSLogFlagEnqueueFetchingUnit     ( DDLogFlagVerbose << 3 ) // Emoji: Tangerine (\U0001F34A)
#define TMSLogFlagFetchingUnitsCount      ( DDLogFlagVerbose << 4 ) // Emoji: Crescent Moon (\U0001F319)
#define TMSLogFlagFetchingUnitDiscardable ( DDLogFlagVerbose << 5 ) // Emoji: Fire (\U0001F525)

// Levels
#define TMSLogLevel        ( DDLogFlagDebug | DDLogLevelInfo  )

#define TMSLogInitialTrial( frmt, ... )            LOG_MAYBE( NO, LOG_LEVEL_DEF, TMSLogFlagInitialTrial, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define TMSLogCreateFetchingUnit( frmt, ... )      LOG_MAYBE( NO, LOG_LEVEL_DEF, TMSLogFlagCreateFetchingUnit, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define TMSLogEnqueueFetchingUnit( frmt, ... )     LOG_MAYBE( NO, LOG_LEVEL_DEF, TMSLogFlagEnqueueFetchingUnit, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define TMSLogFetchingUnitsCount( frmt, ... )      LOG_MAYBE( NO, LOG_LEVEL_DEF, TMSLogFlagFetchingUnitsCount, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )
#define TMSLogFetchingUnitDiscardable( frmt, ... ) LOG_MAYBE( NO, LOG_LEVEL_DEF, TMSLogFlagFetchingUnitDiscardable, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__ )

#endif /* TMSLogging_h */