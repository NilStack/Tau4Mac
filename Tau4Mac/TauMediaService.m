//
//  TauMediaService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMediaService.h"

// Private
@interface MediaServiceFetchingUnit_ ()

@property ( strong, readonly ) dispatch_queue_t fetchingQ_;

@property ( strong, readwrite, atomic ) NSURLSessionDataTask* fetchingTask_;

@property ( strong, readwrite, atomic ) NSImage* image_;
@property ( strong, readwrite, atomic ) NSError* error_;
@property ( assign, readwrite, atomic, setter = setFetchingInProgress_: ) BOOL isFetchingInProgres_;

@end // Private

@implementation MediaServiceFetchingUnit_

- ( void ) fetchImageWithURL: ( NSURL* )_URL
                     success: ( void (^)( NSImage* _Image ) )_SuccessHandler
                     failure: ( void (^)( NSError* _Error ) )_FailureHandler
    {
    if ( !self.isFetchingInProgres_ )
        {
        self.isFetchingInProgres_ = YES;

        dispatch_barrier_async( self.fetchingQ_, ( dispatch_block_t )^{
            dispatch_semaphore_t sema = dispatch_semaphore_create( 0 );

            self.fetchingTask_ = [ [ NSURLSession sharedSession ] dataTaskWithURL: _URL
                                                                completionHandler:
            ^( NSData* _Nullable _Data, NSURLResponse* _Nullable _Response, NSError* _Nullable _Error )
                {
                DDLogDebug( @"Callback was invoked." );

                if ( _Data && !_Error )
                    {
                    self.image_ = [ [ NSImage alloc ] initWithData: _Data ];

                    if ( !self.image_ )
                        {
                        self.error_ = [ NSError
                            errorWithDomain: TauCentralDataServiceErrorDomain
                                       code: TauCentralDataServiceInvalidImageURL
                                   userInfo:
                            @{ NSLocalizedDescriptionKey : [ NSString stringWithFormat: @"URL {%@} doesn't point to valid image data.", _Response.URL ]
                             , NSLocalizedRecoverySuggestionErrorKey : @"Please specify a valid image URL."
                             } ];
                        }
                    }
                else
                    self.error_ = _Error;

                self.isFetchingInProgres_ = NO;
                self.fetchingTask_ = nil;

                /* The dispatch_semaphore_signal function increments the count variable by 1
                 * to indicate that a resource has been freed up. */
                dispatch_semaphore_signal( sema );
                } ];

            [ self.fetchingTask_ resume ];

            /* Semaphore count will be -1 */
            dispatch_semaphore_wait( sema, DISPATCH_TIME_FOREVER );

            /* Current concurrent queue is guaranteed to block right now as description in Apple documentation:
             * "If the resulting value is negative, the function tells the kernel to block your thread." */

            /* Since semaphore count is negative value,
             * "The only time it calls down into the kernel is when the resource is not available
             * and the system needs to park your thread until the semaphore is signaled." */
            } );
        }

    dispatch_async( self.fetchingQ_, ( dispatch_block_t )^{

        /* dispatch_semaphore_signal( sem ); was invoked by barrier block.
         * "If there are tasks blocked and waiting for a resource,
         * one of them is subsequently unblocked and allowed to do its work." */

        if ( self.image_ && !self.error_ )
            {
            if ( _SuccessHandler )
                _SuccessHandler( self.image_ );
            }
        else
            {
            if ( _FailureHandler )
                _FailureHandler( self.error_ );
            }
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

@end // MediaServiceFetchingUnit_ class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauMediaService ()

// Images Caching

@property ( strong, readonly ) NSCache* imageCache_;

- ( NSURL* _Nonnull ) imageCacheUrl_: ( NSURL* )_ImageUrl;
- ( NSImage* _Nullable ) loadCacheForImageNamedUrl_: ( NSURL* )_ImageUrl;
- ( void ) getOptThumbUrlsDict_: ( out NSDictionary <NSString*, NSURL*>* __autoreleasing* _Nonnull )_OptUrlsDictptr fromGTLThumbnailDetails_: ( GTLYouTubeThumbnailDetails* )_ThumbnailDetails;
- ( void ) getPreferredImageInCache_: ( out NSImage* __autoreleasing* _Nonnull )_Imageptr forOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_UrlDict;
- ( void ) getPreferredTrialUrl_: ( out NSURL* __autoreleasing* )_Urlptr preferredTrialThumbKey_: ( out NSString* __autoreleasing* )_Keyptr fromOptThumbsUrlDict_: ( NSDictionary <NSString*, NSURL*>* )_OptUrlsDict;
- ( void ) fetchPreferredThumbImageFromOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_UrlsDict success_: ( void (^)( NSImage* _Nullable _Image, BOOL _LoadsFromCache ) )_SuccessHandler failure_: ( void (^)( NSError* _Nullable _Errpr ) )_FailureHandler;

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

NSString static* const kPreferredThumbOptKey = @"kPreferredThumbKey";
NSString static* const kBackingThumbOptKey = @"kBackingThumbKey";

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

    [ self fetchPreferredThumbImageFromOptThumbUrlsDict_: optThumbUrlsDict
                                                success_:
    ^( NSImage* _Nullable _ThumbImage, BOOL _LoadsFromCache )
        {
        if ( _SuccessHandler )
            _SuccessHandler( _ThumbImage, _ThumbnailDetails, _LoadsFromCache );
        } failure_: ^( NSError* _Errpr )
            {
            if ( _FailureHandler )
                _FailureHandler( _Errpr );
            } ];
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

- ( void ) getPreferredImageInCache_: ( out NSImage* __autoreleasing* _Nonnull )_Imageptr forOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict
    {
    NSURL* trialUrl = nil;
    NSString* trialThumbKey = nil;
    NSMutableDictionary* trails = [ _OptThumbUrlsDict mutableCopy ];
    [ self getPreferredTrialUrl_: &trialUrl preferredTrialThumbKey_: &trialThumbKey fromOptThumbsUrlDict_: trails ];

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

- ( void ) getPreferredTrialUrl_: ( out NSURL* __autoreleasing* )_Urlptr
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

NSString static* const kSFTrialsUserDataKey = @"GTM.Session.Fetcher.Trials.UserData.Key";
NSString static* const kSFFetchIdUserDataKey = @"GTM.Session.Fetcher.FetchId.UserData.Key";

- ( void ) fetchPreferredThumbImageFromOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict
                                                success_: ( void (^)( NSImage* _Nullable _Image, BOOL _LoadsFromCache ) )_SuccessHandler
                                                failure_: ( void (^)( NSError* _Nullable _Errpr ) )_FailureHandler
    {
    NSURL* trialUrl = nil;
    NSString* trialThumbKey = nil;
    NSMutableDictionary* trials = [ _OptThumbUrlsDict mutableCopy ];
    [ self getPreferredTrialUrl_: &trialUrl preferredTrialThumbKey_: &trialThumbKey fromOptThumbsUrlDict_: trials ];

    GTMSessionFetcher* fetcher = [ GTMSessionFetcher fetcherWithURL: trialUrl ];
    NSString* fetchID = [ NSString stringWithFormat: @"(fetchID=%@)", TKNonce() ];

    [ fetcher setUserData: @{ kSFTrialsUserDataKey : trials
                            , kSFFetchIdUserDataKey : fetchID
                            } ];

    [ fetcher beginFetchWithCompletionHandler:
    ^( NSData* _Nullable _Data, NSError* _Nullable _Error )
        {
        if ( _Data && !_Error )
            {
            DDLogDebug( @"Finished fetching thumbnail %@", fetchID );

            NSImage* image = [ [ NSImage alloc ] initWithData: _Data ];
            [ _Data writeToURL: [ self imageCacheUrl_: trialUrl ] atomically: YES ];

            if ( _SuccessHandler )
                _SuccessHandler( image, NO );
            }
        else
            {
            if ( [ _Error.domain isEqualToString: kGTMSessionFetcherStatusDomain ] && ( _Error.code == 404 ) )
                {
                NSMutableDictionary* currentTrails = fetcher.userData[ kSFTrialsUserDataKey ];
                DDLogRecoverable( @"404 NOT FOUND. Couldn't fetch the thumb at {%@} error={%@} comment=%@.\n"
                                  "(Attempting to fetch the backing thumbnail...)"
                                 , currentTrails[ kPreferredThumbOptKey ]
                                 , _Error
                                 , fetcher.comment
                                 );

                [ currentTrails removeObjectForKey: trialThumbKey ];
                [ self fetchPreferredThumbImageFromOptThumbUrlsDict_: currentTrails success_: _SuccessHandler failure_: _FailureHandler ];
                }
            else
                if ( _FailureHandler )
                    _FailureHandler( _Error );
            }
        } ];
    }

@end // TauMediaService class