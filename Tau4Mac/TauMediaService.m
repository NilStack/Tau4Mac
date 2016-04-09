//
//  TauMediaService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMediaService.h"

NSString static* const kPreferredThumbOptKey = @"kPreferredThumbKey";
NSString static* const kBackingThumbOptKey = @"kBackingThumbKey";

// Internal Notification Names
NSString static* const kFetchingUnitBecomeDiscardable = @"MediaServiceFetchingUnit.BecomeDiscardable.Notif";

// Internal Notification UserInfo Keys
NSString static* const kImageData = @"kImageData";

// Private
@interface MediaServiceDisposableFetchingUnit_ ()

// Writability Swizzling
@property ( assign, readwrite, atomic, setter = setDiscardable: ) BOOL isDiscardable;

@property ( strong, readonly ) dispatch_queue_t fetchingQ_;
@property ( strong, readonly ) dispatch_group_t syncGroup_;

@property ( strong, readwrite, atomic ) NSURLSessionDataTask* fetchingTask_;

@property ( strong, readwrite, atomic ) NSData* imageData_;
@property ( strong, readwrite, atomic ) NSImage* image_;
@property ( strong, readwrite, atomic ) NSError* error_;
@property ( assign, readwrite, atomic, setter = setFetchingInProgress_: ) BOOL isFetchingInProgres_;

+ ( void ) getPreferredTrialUrl_: ( out NSURL* __autoreleasing* )_Urlptr preferredTrialThumbKey_: ( out NSString* __autoreleasing* )_Keyptr fromOptThumbsUrlDict_: ( NSDictionary <NSString*, NSURL*>* )_OptUrlsDict;

@end // Private

@implementation MediaServiceDisposableFetchingUnit_

- ( instancetype ) init
    {
    if ( self = [ super init ] )
        self.isDiscardable = YES;
    return self;
    }

NSString static* const kSFTrialsUserDataKey = @"GTM.Session.Fetcher.Trials.UserData.Key";
NSString static* const kSFFetchIdUserDataKey = @"GTM.Session.Fetcher.FetchId.UserData.Key";

+ ( void ) getPreferredTrialUrl_: ( out NSURL* __autoreleasing* )_Urlptr
         preferredTrialThumbKey_: ( out NSString* __autoreleasing* )_Keyptr
           fromOptThumbsUrlDict_: ( NSDictionary <NSString*, NSURL*>* )_OptUrlsDict
    {
    NSURL* url = nil;
    NSString* thumbKey = nil;

    if ( ( url = _OptUrlsDict[ kPreferredThumbOptKey ] ) )
        thumbKey = kPreferredThumbOptKey;
    else if ( ( url = _OptUrlsDict[ kBackingThumbOptKey ] ) )
        thumbKey = kBackingThumbOptKey;

    if ( url && _Urlptr )
        *_Urlptr = url;

    if ( thumbKey && _Keyptr )
        *_Keyptr = thumbKey;
    }

- ( void ) fetchPreferredThumbImageFromOptThumbUrlsDict: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict
                                                success: ( void (^)( NSImage* _Image, BOOL _LoadsFromCache ) )_SuccessHandler
                                                failure: ( void (^)( NSError* _Errpr ) )_FailureHandler
    {
    if ( !self.isFetchingInProgres_ )
        {
        self.isFetchingInProgres_ = YES;
        self.isDiscardable = NO;

        dispatch_barrier_async( self.fetchingQ_, ( dispatch_block_t )^{

            dispatch_semaphore_t sema = dispatch_semaphore_create( 0 );

            NSURL* trialUrl = nil;
            NSString* trialThumbKey = nil;
            NSMutableDictionary* trials = [ _OptThumbUrlsDict mutableCopy ];
            [ self.class getPreferredTrialUrl_: &trialUrl preferredTrialThumbKey_: &trialThumbKey fromOptThumbsUrlDict_: trials ];

            GTMSessionFetcher* fetcher = [ GTMSessionFetcher fetcherWithURL: trialUrl ];
            NSString* fetchID = [ NSString stringWithFormat: @"(fetchId=%@)", TKNonce() ];

            [ fetcher setUserData: @{ kSFTrialsUserDataKey : trials, kSFFetchIdUserDataKey : fetchID } ];

            [ fetcher beginFetchWithCompletionHandler:
            ^( NSData* _Nullable _Data, NSError* _Nullable _Error )
                {
                if ( _Data && !_Error )
                    {
                    DDLogDebug( @"Finished fetching with identifier %@", fetchID );

                    self.image_ = [ [ NSImage alloc ] initWithData: _Data ];
                    if ( !self.image_ )
                        {
                        self.error_ = [ NSError
                            errorWithDomain: TauCentralDataServiceErrorDomain
                                       code: TauCentralDataServiceInvalidImageURL
                                   userInfo:
                            @{ NSLocalizedDescriptionKey : [ NSString stringWithFormat: @"URL {%@} doesn't point to valid image data.", @"" /* TODO: Expecting a valid URL */ ]
                             , NSLocalizedRecoverySuggestionErrorKey : @"Please specify a valid image URL."
                             } ];
                        }
                    else
                        self.imageData_ = _Data;

                    self.isFetchingInProgres_ = NO;

                    /* The dispatch_semaphore_signal function increments the count variable by 1
                     * to indicate that a resource has been freed up. */
                    dispatch_semaphore_signal( sema );
                    }
                else
                    {
                    if ( [ _Error.domain isEqualToString: kGTMSessionFetcherStatusDomain ] && ( _Error.code == 404 ) )
                        {
                        NSMutableDictionary* currentTrails = fetcher.userData[ kSFTrialsUserDataKey ];
                        DDLogNotice( @"404 not found. Couldn't fetch the thumb at {%@} error={%@} comment=%@.\n"
                                      "(Attempting to fetch the backing thumbnail...)"
                                   , currentTrails[ kPreferredThumbOptKey ]
                                   , _Error
                                   , fetcher.comment
                                   );

                        [ currentTrails removeObjectForKey: trialThumbKey ];
                        [ self fetchPreferredThumbImageFromOptThumbUrlsDict: currentTrails success: _SuccessHandler failure: _FailureHandler ];
                        }
                    else
                        {
                        self.error_ = _Error;
                        self.isFetchingInProgres_ = NO;
                        dispatch_semaphore_signal( sema );
                        }
                    }
                } ];

            /* Semaphore count will be -1 */
            dispatch_semaphore_wait( sema, DISPATCH_TIME_FOREVER );

            /* Current concurrent queue is guaranteed to block right now as description in Apple documentation:
             * "If the resulting value is negative, the function tells the kernel to block your thread." */

            /* Since semaphore count is negative value,
             * "The only time it calls down into the kernel is when the resource is not available
             * and the system needs to park your thread until the semaphore is signaled." */
            } );
        }

    dispatch_group_async( self.syncGroup_, self.fetchingQ_, ( dispatch_block_t )^{

        /* dispatch_semaphore_signal( sem ); was invoked by barrier block.
         * "If there are tasks blocked and waiting for a resource,
         * one of them is subsequently unblocked and allowed to do its work." */

        if ( self.image_ && !self.error_ )
            {
            if ( _SuccessHandler )
                _SuccessHandler( self.image_, NO );
            }
        else
            {
            if ( _FailureHandler )
                _FailureHandler( self.error_ );
            }
        } );

    dispatch_once_t static onceToken;
    dispatch_once( &onceToken, ( dispatch_block_t )^{
        dispatch_group_notify( self.syncGroup_, dispatch_get_main_queue(), ^{
            self.isDiscardable = YES;
            NSMutableDictionary* userInfoDict = [ NSMutableDictionary dictionary ];
            userInfoDict[ kImageData ] = self.imageData_;
            NSNotification* notif = [ NSNotification notificationWithName: kFetchingUnitBecomeDiscardable object: self userInfo: ( userInfoDict.count > 0 ) ? userInfoDict : nil ];
            [ [ NSNotificationCenter defaultCenter ] postNotification: notif ];
            } );
        } );
    }

#pragma mark - Private

@synthesize fetchingQ_ = priFetchingQ_;
- ( dispatch_queue_t ) fetchingQ_
    {
    if ( !priFetchingQ_ )
        priFetchingQ_ = dispatch_queue_create( "home.bedroom.TongKuo.Tau4Mac.TauMediaService", DISPATCH_QUEUE_CONCURRENT );
    return priFetchingQ_;
    }

@synthesize syncGroup_ = priSyncGroup_;
- ( dispatch_group_t ) syncGroup_
    {
    if ( !priSyncGroup_ )
        priSyncGroup_ = dispatch_group_create();
    return priSyncGroup_;
    }

@end // MediaServiceDisposableFetchingUnit_ class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauMediaService ()

@property ( strong, readonly ) NSMapTable <NSDictionary <NSString*, NSURL*>*, MediaServiceDisposableFetchingUnit_*>* disposableFetchingUnits_;

// Images Caching

@property ( strong, readonly ) NSCache* imageCache_;

- ( NSImage* _Nullable ) loadCacheForImageNamedUrl_: ( NSURL* )_ImageUrl;
- ( NSURL* _Nonnull ) imageCacheUrl_: ( NSURL* )_ImageUrl;
- ( void ) getOptThumbUrlsDict_: ( out NSDictionary <NSString*, NSURL*>* __autoreleasing* _Nonnull )_OptUrlsDictptr fromGTLThumbnailDetails_: ( GTLYouTubeThumbnailDetails* )_ThumbnailDetails;
- ( void ) getPreferredImageInCache_: ( out NSImage* __autoreleasing* _Nonnull )_Imageptr forOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_UrlDict;

@end // Private

// TauMediaService class
@implementation TauMediaService

#pragma mark - Singleton Instance

TauMediaService static* sMediaService_;
+ ( instancetype ) sharedService
    {
    return [ [ self alloc ] init ];
    }

- ( instancetype ) init
    {
    if ( !sMediaService_ )
        if ( self = [ super init ] )
            sMediaService_ = self;

    return sMediaService_;
    }

#pragma mark - Remote Image & Video Fetching

- ( void ) fetchPreferredThumbnailFrom: ( GTLYouTubeThumbnailDetails* )_ThumbnailDetails
                               success: ( void (^)( NSImage* _Image, GTLYouTubeThumbnailDetails* _ThumbnailDetails, BOOL _LoadsFromCache ) )_SuccessHandler
                               failure: ( void (^)( NSError* _Error ) )_FailureHandler
    {
    NSDictionary <NSString*, NSURL*>* optThumbUrlsDict = nil;
    [ self getOptThumbUrlsDict_: &optThumbUrlsDict fromGTLThumbnailDetails_: _ThumbnailDetails ];

    NSImage* cachedImage = nil;
    [ self getPreferredImageInCache_: &cachedImage forOptThumbUrlsDict_: optThumbUrlsDict ];
    if ( cachedImage )
        {
        if ( _SuccessHandler )
            _SuccessHandler ( cachedImage, _ThumbnailDetails, YES );
        return;
        }

    MediaServiceDisposableFetchingUnit_* fetchingUnit = nil;
    if ( !( fetchingUnit = [ self.disposableFetchingUnits_ objectForKey: optThumbUrlsDict ] ) )
        {
        fetchingUnit = [ [ MediaServiceDisposableFetchingUnit_ alloc ] init ];
        [ self.disposableFetchingUnits_ setObject: fetchingUnit forKey: optThumbUrlsDict ];
        }

    [ fetchingUnit fetchPreferredThumbImageFromOptThumbUrlsDict: optThumbUrlsDict
                                                        success:
    ^( NSImage* _Nullable _ThumbImage, BOOL _LoadsFromCache )
        {
        if ( _SuccessHandler )
            dispatch_sync( dispatch_get_main_queue(), ( dispatch_block_t )^{
                _SuccessHandler( _ThumbImage, _ThumbnailDetails, _LoadsFromCache );
            } );
        } failure: ^( NSError* _Errpr )
            {
            if ( _FailureHandler )
                dispatch_sync( dispatch_get_main_queue(), ( dispatch_block_t )^{
                    _FailureHandler( _Errpr );
                } );
            } ];
    }

#pragma mark - Private

@synthesize disposableFetchingUnits_ = priDisposableFetchingUnits_;
- ( NSMapTable <NSDictionary <NSString*, NSURL*>*, MediaServiceDisposableFetchingUnit_*>* ) disposableFetchingUnits_
    {
    if ( !priDisposableFetchingUnits_ )
        priDisposableFetchingUnits_ = [ NSMapTable mapTableWithKeyOptions: NSPointerFunctionsStrongMemory valueOptions: NSPointerFunctionsStrongMemory ];
    return priDisposableFetchingUnits_;
    }

// Images Caching

@synthesize imageCache_ = priImageCache_;
- ( NSCache* ) imageCache_
    {
    if ( !priImageCache_ )
        {
        priImageCache_ = [ [ NSCache alloc ] init ];
        [ priImageCache_ setTotalCostLimit: 100 * pow( 1024, 2 ) ];
        [ priImageCache_ setDelegate: self ];
        }

    return priImageCache_;
    }


- ( NSImage* _Nullable ) loadCacheForImageNamedUrl_: ( NSURL* )_ImageUrl
    {
    NSImage* awakenImage = nil;

    NSURL* cacheURL = [ self imageCacheUrl_: _ImageUrl ];
    BOOL isDir = NO;
    if ( [ [ NSFileManager defaultManager ] fileExistsAtPath: cacheURL.path isDirectory: &isDir ] && !isDir )
        awakenImage = [ [ NSImage alloc ] initWithContentsOfURL: cacheURL ];

    return awakenImage;
    }

- ( void ) getOptThumbUrlsDict_: ( out NSDictionary <NSString*, NSURL*>* __autoreleasing* _Nonnull )_OptUrlsDictptr
       fromGTLThumbnailDetails_: ( GTLYouTubeThumbnailDetails* )_ThumbnailDetails
    {
    // Pick up the thumbnail that has the highest definition as far as possible
    GTLYouTubeThumbnail* preferredThumbnail =
            /* 1280x720 px */
        _ThumbnailDetails.maxres
            /* 640x480 px */
            ?: _ThumbnailDetails.standard
            /* 480x360 px */
            ?: _ThumbnailDetails.high
            /* 320x180 px */
            ?: _ThumbnailDetails.medium
            /* 120x90 px */
            ?: _ThumbnailDetails.defaultProperty
             ;

    if ( !preferredThumbnail )
        {
        DDLogUnexpected( @"Coundn't find out the preferred thumbnail from {%@}.", preferredThumbnail );
        return;
        }

    NSMutableDictionary* urlsDictResult = [ NSMutableDictionary dictionary ];

    NSURL* backingUrl = nil;
    NSURL* preferredUrl = nil;

    if ( ( backingUrl = [ NSURL URLWithString: preferredThumbnail.url ] ) )
        [ urlsDictResult addEntriesFromDictionary: @{ kBackingThumbOptKey : backingUrl } ];

    NSString* maxresName = @"maxresdefault.jpg";
    if ( ![ [ backingUrl.lastPathComponent stringByDeletingPathExtension ] isEqualToString: maxresName ] )
        if ( ( preferredUrl = [ [ backingUrl URLByDeletingLastPathComponent ] URLByAppendingPathComponent: maxresName ] ) )
            [ urlsDictResult addEntriesFromDictionary: @{ kPreferredThumbOptKey : preferredUrl } ];

    if ( urlsDictResult.count > 0 )
        {
        if ( _OptUrlsDictptr )
            *_OptUrlsDictptr = [ urlsDictResult copy ];
        }
    else
        DDLogUnexpected( @"Urls dict I/O argument didn't get polulated from {%@}.", _ThumbnailDetails );
    }

- ( NSURL* _Nonnull ) imageCacheUrl_: ( NSURL* )_ImageUrl
    {
    NSData* cacheNameData = [ [ _ImageUrl.path stringByRemovingPercentEncoding ] dataUsingEncoding: NSUTF8StringEncoding ];
    unsigned char buffer[ CC_SHA1_DIGEST_LENGTH ];
    CC_SHA1( cacheNameData.bytes, ( unsigned int )( cacheNameData.length ), buffer );

    NSData* hashedCacheName = [ NSData dataWithBytes: buffer length: CC_SHA1_DIGEST_LENGTH ];
    NSError* err = nil;
    NSURL* cacheURL = [ [ NSFileManager defaultManager ] URLForDirectory: NSCachesDirectory inDomain: NSUserDomainMask appropriateForURL: nil create: YES error: &err ];
    cacheURL = [ cacheURL URLByAppendingPathComponent: hashedCacheName.description ];
    if ( !cacheURL )
        DDLogFatal( @"Failed to create the cache dir with error: {%@}.", err );

    return cacheURL;
    }

- ( void ) getPreferredImageInCache_: ( out NSImage* __autoreleasing* _Nonnull )_Imageptr forOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict
    {
    NSURL* trialUrl = nil;
    NSString* trialThumbKey = nil;
    NSMutableDictionary* trails = [ _OptThumbUrlsDict mutableCopy ];
    [ MediaServiceDisposableFetchingUnit_ getPreferredTrialUrl_: &trialUrl preferredTrialThumbKey_: &trialThumbKey fromOptThumbsUrlDict_: trails ];

    NSImage* image = [ self loadCacheForImageNamedUrl_: trialUrl ];
    if ( image )
        {
        if ( _Imageptr )
            *_Imageptr = image;
        }
    else
        {
        if ( trails.count > 0 )
            {
            [ trails removeObjectForKey: trialThumbKey ];
            [ self getPreferredImageInCache_: _Imageptr forOptThumbUrlsDict_: trails ];
            }
        }
    }

@end // TauMediaService class