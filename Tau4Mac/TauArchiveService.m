//
//  TauArchiveService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/13/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauArchiveService.h"
#import "TauPurgeableImageData.h"

sqlite3 TAU_PRIVATE* s_db_;

/* Create img_archive_tb table */
//char TAU_PRIVATE const* s_sql_create_img_archive_table = "create table ZTAS_IMG_ARCHIVE ( ZTAS_ID integer primary key, ZTAS_IMG_NAME text not null, ZTAS_IMG_BLOB blob not null, unique( ZTAS_IMG_NAME ) );";

/* Insert values ( img_name, img_blob ) into img_archive_tb, only if the unique key (img_name) does not exist. */
//char TAU_PRIVATE const* s_sql_insert_img_archive = "insert or ignore into ZTAS_IMG_ARCHIVE ( ZTAS_IMG_NAME, ZTAS_IMG_BLOB ) values( :zimgname, :zimgblob );";

/* Get the img_blob corresponding img_name */
//char TAU_PRIVATE const* s_sql_select_img_archive = "select ZTAS_IMG_BLOB from ZTAS_IMG_ARCHIVE where ZTAS_IMG_NAME=:zimgname;";

dispatch_queue_t TAU_PRIVATE s_serial_archive_querying_queue_;

// Logging callback
void TAU_PRIVATE err_log_cbk ( void* _pArgc, int _err, char const* _zMsg )
    {
    DDLogFatal( @"[tvs](errcode=%d msg=%s)", _err, _zMsg );
    }

#define TVSTbNameImgArchive @"ZTVS_IMG_ARCHIVE"
#define TVSColNameID        @"ZTVS_ID"
#define TVSColNameImgName   @"ZTVS_IMG_NAME"
#define TVSColNameImgBlob   @"ZTVS_IMG_BLOB"

#define TVS_IMGNAME_BIND_PARAM ":zimgname"
#define TVS_IMGBLOB_BIND_PARAM ":zimgblob"

sqlite3_stmt TAU_PRIVATE* stmt_CREATE_img_archive_tb_;
sqlite3_stmt TAU_PRIVATE* stmt_SELECT_from_img_archive_tb_;
sqlite3_stmt TAU_PRIVATE* stmt_INSERT_into_img_archive_tb_;

#define TauAssert( CONDITION, FRMT, ... ) \
if ( !( CONDITION ) ) { \
NSString* desc = [ NSString stringWithFormat: FRMT, ## __VA_ARGS__ ]; \
NSLog( @"%@", desc ); \
assert( CONDITION ); \
}

#define TauAssertCondition( CONDITION ) \
TauAssert( CONDITION, @"condition not satisfied: %s", #CONDITION )

#define TVSAssertSQLite3PrepareV2( DB, SQL, STMT_PTR ) \
do { \
int rc = SQLITE_OK; \
rc = sqlite3_prepare_v2( DB, SQL.UTF8String, -1, &STMT_PTR, NULL ); \
TauAssert( ( rc == SQLITE_OK ), @"[tvs]failed preparing the SQL statement {%@} with error code: %d", SQL, rc ); \
} while ( 0 )

inline void TAU_PRIVATE prepared_sql_init_()
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken, ( dispatch_block_t )^{

        // Create img_archive_tb table
        NSString* sqlTemplate = nil;
        NSString* sql = nil;

        sqlTemplate = @"create table %@ ( %@ integer primary key, %@ text not null, %@ blob not null, unique( %@ ) );";
        sql = [ NSString stringWithFormat: sqlTemplate
              , /*CREATE TABLE*/ TVSTbNameImgArchive
              , /*(*/ TVSColNameID /*INTEGER PRIMARY KEY*/, TVSColNameImgName /*TEXT NOT NULL*/, TVSColNameImgBlob /*BLOB NOT NULL*/
              , /*UNIQUE(*/ TVSColNameImgName /*)*/
                /*);*/ ];

        TVSAssertSQLite3PrepareV2( s_db_, sql, stmt_CREATE_img_archive_tb_ );

        // Insert values ( img_name, img_blob ) into img_archive_tb, only if the unique key (img_name) does not exist
        sqlTemplate = @"insert or ignore into %@ ( %@, %@ ) values( %@, %@ );";
        sql = [ NSString stringWithFormat: sqlTemplate
              , /*INSERT OR IGNORE INTO*/ TVSTbNameImgArchive
              , /*(*/TVSColNameImgName, TVSColNameImgBlob /*)*/
              , /*VALUES(*/ TVS_IMGNAME_BIND_PARAM, TVS_IMGBLOB_BIND_PARAM /*)*/
                /*);*/ ];

        TVSAssertSQLite3PrepareV2( s_db_, sql, stmt_INSERT_into_img_archive_tb_ );

        // Get the img_blob corresponding img_name
        sqlTemplate = @"select %@ from %@ where %@=%@;";
        sql = [ NSString stringWithFormat: sqlTemplate
              , /*SELECT*/ TVSColNameImgBlob, /*FROM*/ TVSTbNameImgArchive, /*WHERE*/ TVSColNameImgName, /*=*/ TVS_IMGNAME_BIND_PARAM ];

        TVSAssertSQLite3PrepareV2( s_db_, sql, stmt_SELECT_from_img_archive_tb_ );
        } );
    }

inline sqlite3_stmt TAU_PRIVATE* prepared_sql_create_img_archive_tb ()
    {
    prepared_sql_init_();
    return stmt_CREATE_img_archive_tb_;
    }

inline sqlite3_stmt TAU_PRIVATE* prepared_sql_select_from_img_archive_tb ()
    {
    prepared_sql_init_();
    return stmt_SELECT_from_img_archive_tb_;
    }

inline sqlite3_stmt TAU_PRIVATE* prepared_sql_insert_into_img_archive_tb ()
    {
    prepared_sql_init_();
    return stmt_INSERT_into_img_archive_tb_;
    }

// TauArchiveService class
@implementation TauArchiveService

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
            if ( ( rc = sqlite3_open_v2( archiveDBLoc.absoluteString.UTF8String, &s_db_, SQLITE_OPEN_READWRITE, NULL ) ) != SQLITE_OK )
                needsCreate = YES;
            }
        }

    if ( needsCreate )
        rc = sqlite3_open_v2( archiveDBLoc.absoluteString.UTF8String, &s_db_, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL );

    if ( rc == SQLITE_OK )
        {
        sqlite3_stmt* stmt = sqlite3_prepared_sql_create_img_archive_tb();
        sqlite3_bind_text( stmt, <#int#>, <#const char *#>, <#int#>, <#void (*)(void *)#>)

        rc = sqlite3_exec( s_db_, s_sql_create_img_archive_table, NULL, NULL, NULL );
        }
    else
        ; // TODO: Expecting to raise an exception

    s_serial_archive_querying_queue_ = dispatch_queue_create( "home.bedroom.TongKuo.Tau4Mac.TauArchiveService", DISPATCH_QUEUE_SERIAL );
    }

+ ( void ) syncArchiveImage: ( TauPurgeableImageData* )_ImageDat
                       name: ( NSString* )_ImageName
                      error: ( NSError** )_Error
    {
    int rc = SQLITE_OK;

    int idx_of_zimgname = sqlite3_bind_parameter_index( stmt_INSERT_into_img_archive_tb_, TVS_IMGNAME_BIND_PARAM );
    rc = sqlite3_bind_text( stmt_INSERT_into_img_archive_tb_, idx_of_zimgname, _ImageName.UTF8String, ( int )_ImageName.length, SQLITE_STATIC );

    int idx_of_zimgblob = sqlite3_bind_parameter_index( stmt_INSERT_into_img_archive_tb_, TVS_IMGBLOB_BIND_PARAM );
    rc = sqlite3_bind_blob64( stmt_INSERT_into_img_archive_tb_, idx_of_zimgblob, _ImageDat.bytes, ( int )_ImageDat.length, SQLITE_STATIC );

    rc = sqlite3_step( stmt_INSERT_into_img_archive_tb_ );
    sqlite3_reset( stmt_INSERT_into_img_archive_tb_ );
    }

+ ( void ) asyncArchiveImage: ( TauPurgeableImageData* )_ImageDat
                        name: ( NSString* )_ImageName
               dispatchQueue: ( dispatch_queue_t )_DispatchQueue
           completionHandler: ( void (^)( NSError* _Error ) )_Handler
    {
    dispatch_async( s_serial_archive_querying_queue_, ( dispatch_block_t )^{
        NSError* err = nil;
        [ self syncArchiveImage: _ImageDat name: _ImageName error: &err ];

        dispatch_queue_t q = _DispatchQueue ?: dispatch_get_main_queue();
        dispatch_async( q, ( dispatch_block_t )^{
            // TODO: Expecting the error handling
            _Handler( err );
            } );
        } );
    }

+ ( void ) imageArchiveWithImageName: ( NSString* )_ImageName
                       dispatchQueue: ( dispatch_queue_t )_DispatchQueue
                   completionHandler: ( void (^)( TauPurgeableImageData* _ImageDat, NSError* _Error ) )_Handler
    {
    dispatch_async( s_serial_archive_querying_queue_, ( dispatch_block_t )^{

        int rc = SQLITE_OK;

        int idx_of_zimgname = sqlite3_bind_parameter_index( stmt_SELECT_from_img_archive_tb_, ":zimgname" );
        rc = sqlite3_bind_text( stmt_SELECT_from_img_archive_tb_, idx_of_zimgname, _ImageName.UTF8String, ( int )_ImageName.length, SQLITE_STATIC );

        rc = sqlite3_step( stmt_SELECT_from_img_archive_tb_ );
        if ( rc != SQLITE_ROW && rc != SQLITE_DONE )
            {
            DDLogFatal( @"[tvs]error occured" );
            sqlite3_reset( stmt_SELECT_from_img_archive_tb_ );
            return;
            }

        int cols = sqlite3_column_count( stmt_SELECT_from_img_archive_tb_ );
        char const* expec = "ZTAS_IMG_BLOB";
        void const* blob = NULL;
        int blob_len = 0;

        for ( int _Index = 0; _Index < cols; _Index++ )
            {
            char const* colName = sqlite3_column_name( stmt_SELECT_from_img_archive_tb_, _Index );
            if ( strncmp( colName, expec, strlen( expec ) ) == 0 )
                {
                blob = sqlite3_column_blob( stmt_SELECT_from_img_archive_tb_, _Index );
                blob_len = sqlite3_column_bytes( stmt_SELECT_from_img_archive_tb_, _Index );
                }
            }

        TauPurgeableImageData* dat = nil;
        if ( blob && ( blob_len > 0 ) )
            dat = [ [ TauPurgeableImageData alloc ] initWithBytes: blob length: blob_len ];

        if ( _Handler )
            {
            dispatch_queue_t q = _DispatchQueue ?: dispatch_get_main_queue();
            dispatch_async( q, ( dispatch_block_t )^{
                _Handler( dat, nil );
                } );
            }

        sqlite3_reset( stmt_SELECT_from_img_archive_tb_ );
        } );
    }

@end // TauArchiveService class