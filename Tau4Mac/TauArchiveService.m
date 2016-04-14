//
//  TauArchiveService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/13/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauArchiveService.h"
#import "TauPurgeableImageData.h"

#define TVSTbNameImgArchive "ZTVS_IMG_ARCHIVE"
#define TVSColNameID        "ZTVS_ID"
#define TVSColNameImgName   "ZTVS_IMG_NAME"
#define TVSColNameImgBlob   "ZTVS_IMG_BLOB"

#define TVS_IMGNAME_BIND_PARAM ":zimgname"
#define TVS_IMGBLOB_BIND_PARAM ":zimgblob"

sqlite3 TAU_PRIVATE* db_;

dispatch_queue_t TAU_PRIVATE serial_archive_querying_queue_;

#if DEBUG
void TAU_PRIVATE err_log_cbk ( void* _pArgc, int _err, char const* _zMsg ) { DDLogUnexpected( @"[tvs](errcode=%d msg=%s)", _err, _zMsg ); }
#endif

sqlite3_stmt TAU_PRIVATE* stmt_CREATE_img_archive_tb_;
sqlite3_stmt TAU_PRIVATE* stmt_SELECT_from_img_archive_tb_;
sqlite3_stmt TAU_PRIVATE* stmt_INSERT_into_img_archive_tb_;

#define TVSAssertSQLiteV3PrepareV2( DB, SQL, STMT ) \
do { \
int __rc__ = SQLITE_OK; \
size_t sqllen = strlen( SQL.UTF8String ) + 1; \
char copy[ sqllen ]; \
stpncpy( copy, SQL.UTF8String, sqllen ); \
__rc__ = sqlite3_prepare_v2( DB, copy, -1, &STMT, NULL ); \
TauStrictAssert( ( __rc__ == SQLITE_OK ), @"[tvs]failed preparing the SQL statement {\n\t%s\n} with error code (%d) in SQLite domain.", copy, __rc__ ); \
DDLogExpecting( @"[tvs]prepared SQL statement {\n\t%s\n} for execution.", copy ); \
} while ( 0 )

#define TVSSQLiteErrorHandlingPoint TVS_SQLITE_ERROR_HANDLING_POINT

#define TVSExecuteSQLiteV3Func( FUNC, ERRORpr, FLAGpr ) \
do { \
int __rc__ = SQLITE_OK; \
BOOL* __flagpr__ = FLAGpr; \
__rc__ = FUNC; \
\
if ( ( __rc__ != SQLITE_OK ) && ( __rc__ != SQLITE_DONE ) && ( __rc__ != SQLITE_ROW ) ) { \
if ( __flagpr__ ) *__flagpr__ = NO; \
/* constructing underlying SQLite error... */ \
NSError* underlyingErr = [ NSError errorWithDomain: TauSQLiteV3ErrorDomain code: __rc__ \
userInfo: @{ NSLocalizedDescriptionKey : [ NSString stringWithUTF8String: sqlite3_errstr( __rc__ ) ] } ]; \
/* constructing the TVS level error... */ \
NSError* __err__ = [ NSError errorWithDomain: TauCentralDataServiceErrorDomain code: TauCentralDataServiceSQLiteError \
userInfo: @{ \
  NSLocalizedDescriptionKey : NSLocalizedString( @"[tvs]this error occured while interacting with the underlying SQLite database.", nil ) \
, NSLocalizedRecoverySuggestionErrorKey : [ NSString stringWithFormat: \
    NSLocalizedString( @"For details just examine the error description within {%@} field. " \
                        "More further information about SQLite error code at https://www.sqlite.org/rescode.html", nil ), NSUnderlyingErrorKey ] \
, NSUnderlyingErrorKey : underlyingErr } ]; \
NSError* __strong* __errpr__ = ERRORpr; \
if ( __errpr__ ) *__errpr__ = __err__; else DDLogFatal( @"%@", __err__ ); \
} else if ( __flagpr__ ) *__flagpr__ = YES; \
} while ( 0 )

#define TVSLiberalExecuteSQLiteV3Func( FUNC, ERRORpr ) \
do { \
TVSExecuteSQLiteV3Func( FUNC, ERRORpr, nil ); \
} while ( 0 )

#define TVSStrictExecuteSQLiteV3Func( FUNC, ERRORpr ) \
do { \
BOOL flag = NO; \
TVSExecuteSQLiteV3Func( FUNC, ERRORpr, &flag ); \
if ( !flag ) goto TVSSQLiteErrorHandlingPoint; \
} while ( 0 )

inline void TAU_PRIVATE prepared_sql_init_ ()
    {
    dispatch_once_t static onceToken;
    dispatch_once( &onceToken, ( dispatch_block_t )^{

        int rc = SQLITE_OK;

        // Create img_archive_tb table
        NSString* sqlTemplate = nil;
        NSString* sql = nil;

        sqlTemplate = @"create table IF NOT EXISTS %s ( %s integer primary key, %s text NOT null, %s blob NOT null, unique( %s ) );";
        sql = [ NSString stringWithFormat: sqlTemplate
              , /*CREATE TABLE IF NOT EXISTS*/ TVSTbNameImgArchive
              , /*(*/ TVSColNameID /*INTEGER PRIMARY KEY*/, TVSColNameImgName /*TEXT NOT NULL*/, TVSColNameImgBlob /*BLOB NOT NULL*/
              , /*UNIQUE(*/ TVSColNameImgName /*)*/
                /*);*/ ];

        TVSAssertSQLiteV3PrepareV2( db_, sql, stmt_CREATE_img_archive_tb_ );
        rc = sqlite3_step( stmt_CREATE_img_archive_tb_ );

        // Insert values ( img_name, img_blob ) into img_archive_tb, only if the unique key (img_name) does not exist
        sqlTemplate = @"insert OR IGNORE into %s ( %s, %s ) values( %s, %s );";
        sql = [ NSString stringWithFormat: sqlTemplate
              , /*INSERT OR IGNORE INTO*/ TVSTbNameImgArchive
              , /*(*/TVSColNameImgName, TVSColNameImgBlob /*)*/
              , /*VALUES(*/ TVS_IMGNAME_BIND_PARAM, TVS_IMGBLOB_BIND_PARAM /*)*/
                /*);*/ ];

        TVSAssertSQLiteV3PrepareV2( db_, sql, stmt_INSERT_into_img_archive_tb_ );

        // Get the img_blob corresponding img_name
        sqlTemplate = @"select %s from %s WHERE %s=%s;";
        sql = [ NSString stringWithFormat: sqlTemplate
              , /*SELECT*/ TVSColNameImgBlob, /*FROM*/ TVSTbNameImgArchive, /*WHERE*/ TVSColNameImgName, /*=*/ TVS_IMGNAME_BIND_PARAM
                /*;*/ ];

        TVSAssertSQLiteV3PrepareV2( db_, sql, stmt_SELECT_from_img_archive_tb_ );
        } );
    }

#pragma mark - Internal Interfaces

inline sqlite3_stmt TAU_PRIVATE* tvs_prepared_sql_select_from_img_archive_tb ()
    {
    prepared_sql_init_();
    return stmt_SELECT_from_img_archive_tb_;
    }

inline sqlite3_stmt TAU_PRIVATE* tvs_prepared_sql_insert_into_img_archive_tb ()
    {
    prepared_sql_init_();
    return stmt_INSERT_into_img_archive_tb_;
    }

#pragma mark -

// TauArchiveService class
@implementation TauArchiveService

+ ( void ) initialize
    {
    DDLogInfo( @"SQLite Ver: %s", sqlite3_version );

#if DEBUG
    sqlite3_config( SQLITE_CONFIG_LOG, err_log_cbk, NULL );
#endif
    sqlite3_initialize();

    NSError* error = nil;
    NSFileManager* fm = [ NSFileManager defaultManager ];

    NSURL* appLvlArchiveDir = [ [ NSFileManager defaultManager ] URLForDirectory: NSCachesDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: YES error: &error ];
    appLvlArchiveDir = [ appLvlArchiveDir URLByAppendingPathComponent: [ NSBundle mainBundle ].bundleIdentifier ];

    if ( ![ appLvlArchiveDir checkResourceIsReachableAndReturnError: nil ] )
        [ fm createDirectoryAtURL: appLvlArchiveDir withIntermediateDirectories: YES attributes: nil error: &error ];

    NSURL* archiveDBLoc = [ appLvlArchiveDir URLByAppendingPathComponent: @"usrdat.archive" ];
    BOOL isDir = NO;
    BOOL needsCreate = NO;
    if ( !( needsCreate = ![ fm fileExistsAtPath: archiveDBLoc.path isDirectory: &isDir ] ) )
        {
        if ( isDir )
            {
            // FIXME: sqlite3_open_v2() wouldn't be invoked successfully after executing this line of code
            [ fm removeItemAtURL: archiveDBLoc error: &error ];
            needsCreate = YES;
            }
        else
            {
            BOOL res = NO;
            TVSExecuteSQLiteV3Func( sqlite3_open_v2( archiveDBLoc.absoluteString.UTF8String, &db_, SQLITE_OPEN_READWRITE, NULL ), nil, &res );
            needsCreate = !res;
            }
        }

    if ( needsCreate )
        TVSStrictExecuteSQLiteV3Func( sqlite3_open_v2( archiveDBLoc.absoluteString.UTF8String, &db_, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL ), &error );

    serial_archive_querying_queue_ = dispatch_queue_create( "home.bedroom.TongKuo.Tau4Mac.TauArchiveService", DISPATCH_QUEUE_SERIAL );

TVSSQLiteErrorHandlingPoint:
    TauStrictAssert( error == nil, @"[tvs]failed initializing the Tau Archive Service with error {%@}", error );
    }

+ ( void ) syncArchiveImage: ( TauPurgeableImageData* )_ImageDat
                       name: ( NSString* )_ImageName
                      error: ( NSError** )_Error
    {
    NSError* error = nil;

    sqlite3_stmt* stmt = tvs_prepared_sql_insert_into_img_archive_tb();

    int idx_of_zimgname = sqlite3_bind_parameter_index( stmt, TVS_IMGNAME_BIND_PARAM );
    TVSStrictExecuteSQLiteV3Func( sqlite3_bind_text( stmt, idx_of_zimgname, _ImageName.UTF8String, ( int )_ImageName.length, SQLITE_STATIC ), &error );

    int idx_of_zimgblob = sqlite3_bind_parameter_index( stmt, TVS_IMGBLOB_BIND_PARAM );
    TVSStrictExecuteSQLiteV3Func( sqlite3_bind_blob64( stmt, idx_of_zimgblob, _ImageDat.bytes, ( int )_ImageDat.length, SQLITE_STATIC ), &error );

    TVSStrictExecuteSQLiteV3Func( sqlite3_step( stmt ), &error );

TVSSQLiteErrorHandlingPoint:
    sqlite3_reset( stmt );

    if ( error )
        {
        if ( _Error )
            *_Error = error;
        else
            DDLogFatal( @"%@", error );
        }
    }

+ ( void ) asyncArchiveImage: ( TauPurgeableImageData* )_ImageDat
                        name: ( NSString* )_ImageName
               dispatchQueue: ( dispatch_queue_t )_DispatchQueue
           completionHandler: ( void (^)( NSError* _Error ) )_Handler
    {
    dispatch_async( serial_archive_querying_queue_, ( dispatch_block_t )^{
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
    dispatch_async( serial_archive_querying_queue_, ( dispatch_block_t )^{

        int rc = SQLITE_OK;

        sqlite3_stmt* stmt = tvs_prepared_sql_select_from_img_archive_tb();

        int idx_of_zimgname = sqlite3_bind_parameter_index( stmt, TVS_IMGNAME_BIND_PARAM );
        rc = sqlite3_bind_text( stmt, idx_of_zimgname, _ImageName.UTF8String, ( int )_ImageName.length, SQLITE_STATIC );

        rc = sqlite3_step( stmt );
        if ( rc != SQLITE_ROW && rc != SQLITE_DONE )
            {
            DDLogFatal( @"[tvs]error occured" );
            sqlite3_reset( stmt );
            return;
            }

        int cols = sqlite3_column_count( stmt );
        char const* expec = TVSColNameImgBlob;
        void const* blob = NULL;
        int blob_len = 0;

        for ( int _Index = 0; _Index < cols; _Index++ )
            {
            char const* colName = sqlite3_column_name( stmt, _Index );
            if ( strncmp( colName, expec, strlen( expec ) ) == 0 )
                {
                blob = sqlite3_column_blob( stmt, _Index );
                blob_len = sqlite3_column_bytes( stmt, _Index );
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

        sqlite3_reset( stmt );
        } );
    }

@end // TauArchiveService class