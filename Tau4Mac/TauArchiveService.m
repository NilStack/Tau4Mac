//
//  TauArchiveService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/13/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauArchiveService.h"
#import "TauPurgeableImageData.h"

// TauArchiveService class
@implementation TauArchiveService

sqlite3 TAU_PRIVATE* sdb_;
sqlite3_stmt TAU_PRIVATE* sselect_stmt_;
sqlite3_stmt TAU_PRIVATE* ssinsert_stmt_;

char static const* s_sql_create_img_archive_table = "create table ZTAS_IMG_ARCHIVE ( ZTAS_ID integer primary key, ZTAS_IMG_NAME text not null, ZTAS_IMG_BLOB blob not null, unique( ZTAS_IMG_NAME ) );";
char static const* s_sql_insert_img_archive = "insert into ZTAS_IMG_ARCHIVE ( ZTAS_IMG_NAME, ZTAS_IMG_BLOB ) values( :zimgname, :zimgblob );";
char static const* s_sql_select_img_archive = "select from ZTAS_IMG_ARCHIVE where ZTAS_IMG_NAME=:zimgname;";

dispatch_queue_t sSerialArchiveQueryingQ_;

void TAU_PRIVATE err_log_cbk ( void* _pArgc, int _err, char const* _zMsg )
    {
    DDLogFatal( @"[tas](errcode=%d msg=%s)", _err, _zMsg );
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

    if ( rc == SQLITE_OK )
        {
        rc = sqlite3_exec( sdb_, s_sql_create_img_archive_table, NULL, NULL, NULL );

        rc = sqlite3_prepare_v2( sdb_, s_sql_select_img_archive, -1, &sselect_stmt_, NULL );
        rc = sqlite3_prepare_v2( sdb_, s_sql_insert_img_archive, -1, &ssinsert_stmt_, NULL );
        }
    else
        ; // TODO: Expecting to raise an exception

    sSerialArchiveQueryingQ_ = dispatch_queue_create( "home.bedroom.TongKuo.Tau4Mac.TauArchiveService", DISPATCH_QUEUE_SERIAL );
    }

+ ( void ) archiveImage: ( TauPurgeableImageData* )_ImageDat
                   name: ( NSString* )_ImageName
          dispatchQueue: ( dispatch_queue_t )_DispatchQueue
      completionHandler: ( void (^)( NSError* _Error ) )_Handler
    {
    dispatch_async( sSerialArchiveQueryingQ_, ( dispatch_block_t )^{

        int rc = SQLITE_OK;

        int idx_of_zimgname = sqlite3_bind_parameter_index( ssinsert_stmt_, ":zimgname" );
        rc = sqlite3_bind_text( ssinsert_stmt_, idx_of_zimgname, _ImageName.UTF8String, ( int )_ImageName.length, SQLITE_STATIC );

        int idx_of_zimgblob = sqlite3_bind_parameter_index( ssinsert_stmt_, ":zimgblob" );
        rc = sqlite3_bind_blob64( ssinsert_stmt_, idx_of_zimgblob, _ImageDat.bytes, ( int )_ImageDat.length, SQLITE_STATIC );

        rc = sqlite3_step( ssinsert_stmt_ );
        sqlite3_reset( ssinsert_stmt_ );
        } );
    }

+ ( void ) imageArchiveWithImageName: ( NSString* )_ImageName
                       dispatchQueue: ( dispatch_queue_t )_DispatchQueue
                   completionHandler: ( void (^)( TauPurgeableImageData* _ImageDat, NSError* _Error ) )_Handler
    {
    dispatch_async( sSerialArchiveQueryingQ_, ( dispatch_block_t )^{

        int rc = SQLITE_OK;

        int idx_of_zimgname = sqlite3_bind_parameter_index( sselect_stmt_, ":zimgname" );
        sqlite3_bind_text( sselect_stmt_, idx_of_zimgname, _ImageName.UTF8String, ( int )_ImageName.length, SQLITE_STATIC );

        rc = sqlite3_step( sselect_stmt_ );
        if ( rc != SQLITE_ROW || rc != SQLITE_DONE )
            {
            DDLogFatal( @"error occured" );
            sqlite3_reset( sselect_stmt_ );
            return;
            }

        int cols = sqlite3_column_count( sselect_stmt_ );
        char const* expec = "ZTAS_IMG_BLOB";
        void const* blob = NULL;
        int blob_len = 0;

        for ( int _Index = 0; _Index < cols; _Index++ )
            {
            char const* colName = sqlite3_column_name( sselect_stmt_, _Index );
            if ( strncmp( colName, expec, strlen( expec ) ) == 0 )
                {
                blob = sqlite3_column_blob( sselect_stmt_, _Index );
                blob_len = sqlite3_column_bytes( sselect_stmt_, _Index );
                }
            }

        if ( blob && ( blob_len > 0 ) )
            {
            TauPurgeableImageData* dat = [ [ TauPurgeableImageData alloc ] initWithBytes: blob length: blob_len ];
            if ( _Handler )
                {
                dispatch_queue_t q = _DispatchQueue ?: dispatch_get_main_queue();
                dispatch_async( q, ( dispatch_block_t )^{
                    _Handler( dat, nil );
                    } );
                }
            }

        sqlite3_reset( sselect_stmt_ );
        } );
    }

@end // TauArchiveService class