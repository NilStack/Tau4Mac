//
//  TauArchiveService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/13/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauArchiveService.h"

// TauArchiveService class
@implementation TauArchiveService

sqlite3 TAU_PRIVATE* sdb_;
void TAU_PRIVATE err_log_cbk ( void* _pArgc, int _err, char const* zMsg )
    {
    DDLogFatal( @"[tas](errcode=%d msg=%s)", _err, zMsg );
    }

+ ( void ) initialize
    {
    DDLogInfo( @"SQLite Ver: %s", sqlite3_version );

    sqlite3_config( SQLITE_CONFIG_LOG, err_log_cbk, NULL );
    sqlite3_initialize();

    NSError* err = nil;
    int rc = SQLITE_OK;

    NSFileManager* fm = [ NSFileManager defaultManager ];

    NSURL* appLvlArchiveDir = [ [ NSFileManager defaultManager ] URLForDirectory: NSCachesDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: YES error: &err ];
    appLvlArchiveDir = [ appLvlArchiveDir URLByAppendingPathComponent: [ NSBundle mainBundle ].bundleIdentifier ];

    if ( ![ appLvlArchiveDir checkResourceIsReachableAndReturnError: nil ] )
        [ fm createDirectoryAtURL: appLvlArchiveDir withIntermediateDirectories: YES attributes: nil error: nil ];

    NSURL* archiveDBLoc = [ appLvlArchiveDir URLByAppendingPathComponent: @"usrdat.archive" ];
    BOOL isDir = NO;
    BOOL needsCreate = NO;
    if ( !( needsCreate = ![ fm fileExistsAtPath: archiveDBLoc.path isDirectory: &isDir ] ) )
        {
        if ( isDir )
            {
            // FIXME: sqlite3_open_v2() wouldn't be invoked successfully after executing this line of code
            [ fm removeItemAtURL: archiveDBLoc error: &err ];
            needsCreate = YES;
            }
        else
            {
            if ( ( rc = sqlite3_open_v2( archiveDBLoc.absoluteString.UTF8String, &sdb_, SQLITE_OPEN_READWRITE, NULL ) ) != SQLITE_OK )
                needsCreate = YES;
            }
        }

    if ( needsCreate )
        rc = sqlite3_open_v2( archiveDBLoc.absoluteString.UTF8String, &sdb_, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL );
    }

+ ( void ) imageArchiveWithImageName: ( NSString* )_ImageName
                   completionHandler: ( void (^)( NSImage* _Image, NSError* _Error ) )_Handler
    {

    }

@end // TauArchiveService class