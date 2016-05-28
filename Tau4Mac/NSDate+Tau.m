//
//  NSDate+Tau.m
//  Tau4Mac
//
//  Created by Tong G. on 5/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "NSDate+Tau.h"

// NSDate + Tau
@implementation NSDate ( Tau )

#pragma mark - Getting Time Intervals

+ ( NSTimeInterval ) timeIntervalFromISO8601Duration: ( NSString* )_ISO8601Duration
    {
    NSTimeInterval interval = -1;

    /* The length of the video. The tag value is an ISO 8601 duration.
    For example, for a video that is at least one minute long and less than one hour long, the duration is in the format PT#M#S,
    in which the letters PT indicate that the value specifies a period of time,
    and the letters M and S refer to length in minutes and seconds, respectively.
    The # characters preceding the M and S letters are both integers that specify the number of minutes (or seconds) of the video.
    For example, a value of PT15M33S indicates that the video is 15 minutes and 33 seconds long.

    If the video is at least one hour long, the duration is in the format PT#H#M#S,
    in which the # preceding the letter H specifies the length of the video in hours and all of the other details are the same as described above.
    If the video is at least one day long, the letters P and T are separated, and the value's format is P#DT#H#M#S.
    Please refer to the ISO 8601 specification for complete details. */
    char const* stringToParse = [ _ISO8601Duration cStringUsingEncoding: NSASCIIStringEncoding ];

    int days = 0, hours = 0, minutes = 0, seconds = 0;
    char const* ptr = stringToParse;
    while ( *ptr )
        {
        if( *ptr == 'P' || *ptr == 'T' )
            {
            ptr++;
            continue;
            }

        int value, charsRead;
        char type;
        if ( sscanf ( ptr, "%d%c%n", &value, &type, &charsRead ) != 2 )
            ;  // handle parse error

        if ( type == 'D' )      days = value;
        else if ( type == 'H' ) hours = value;
        else if ( type == 'M' ) minutes = value;
        else if ( type == 'S' ) seconds = value;
        else {;}  // handle invalid type

        ptr += charsRead;
        }

    interval = ( ( days * 24 + hours ) * 60 + minutes ) * 60 + seconds;
    return interval;
    }

@end // NSDate + Tau