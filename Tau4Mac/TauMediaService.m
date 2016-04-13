//
//  TauMediaService.m
//  Tau4Mac
//
//  Created by Tong G. on 4/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMediaService.h"
#import "TauPurgeableImageData.h"

NSString static* const kPreferredThumbOptKey = @"kPreferredThumbKey";
NSString static* const kBackingThumbOptKey = @"kBackingThumbKey";

// Internal Notification Names
NSString static* const kFetchingUnitBecomeDiscardable = @"MediaServiceFetchingUnit.BecomeDiscardable.Notif";



// ------------------------------------------------------------------------------------------------------------ //



// MediaServiceDisposableFetchingUnit_ class
@interface MediaServiceDisposableFetchingUnit_ : NSObject

@property ( assign, readonly, atomic ) BOOL isDiscardable;
- ( void ) fetchPreferredThumbImageFromOptThumbUrlsDict: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict success: ( void (^)( NSImage* _Image, NSURL* _ChosenURL, BOOL _LoadsFromCache ) )_SuccessHandler failure: ( void (^)( NSError* _Errpr ) )_FailureHandler;

@end

// Private
@interface MediaServiceDisposableFetchingUnit_ ()

// Writability Swizzling

@property ( assign, readwrite, atomic, setter = setDiscardable: ) BOOL isDiscardable;

// Internal

@property ( strong, readonly ) dispatch_queue_t fetchingQ_;
@property ( strong, readonly ) dispatch_group_t syncGroup_;

@property ( strong, readwrite, atomic ) NSImage* image_;
@property ( strong, readwrite, atomic ) NSError* error_;
@property ( copy, readwrite, atomic ) NSURL* url_;

@property ( assign, readwrite, atomic ) BOOL hasSetUpGroupNotify_;

@property ( assign, readwrite, atomic, setter = setFetchingInProgress_: ) BOOL isFetchingInProgres_;

+ ( void ) getPreferredTrialUrl_: ( out NSURL* __autoreleasing* )_Urlptr preferredTrialThumbKey_: ( out NSString* __autoreleasing* )_Keyptr fromOptThumbsUrlDict_: ( NSDictionary <NSString*, NSURL*>* )_OptUrlsDict;
- ( void ) priFetchPreferredThumbImageFromOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict success_: ( void (^)( NSImage* _Image, NSURL* _ChosenURL, BOOL _LoadsFromCache ) )_SuccessHandler failure_: ( void (^)( NSError* _Nullable _Errpr ) )_FailureHandler;

@end // Private

@implementation MediaServiceDisposableFetchingUnit_

- ( void ) fetchPreferredThumbImageFromOptThumbUrlsDict: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict
                                                success: ( void (^)( NSImage* _Image, NSURL* _ChosenURL, BOOL _LoadsFromCache ) )_SuccessHandler
                                                failure: ( void (^)( NSError* _Errpr ) )_FailureHandler
    {
    if ( self.isDiscardable )
        {
        DDLogFatal( @"[tms]the disposable fetching unit {%@} has been marked as discardable.", self );
        return;
        }

    if ( !self.isFetchingInProgres_ )
        {
        self.isFetchingInProgres_ = YES;

        dispatch_barrier_async( self.fetchingQ_, ( dispatch_block_t )^{
            dispatch_semaphore_t sema = dispatch_semaphore_create( 0 );

            [ self priFetchPreferredThumbImageFromOptThumbUrlsDict_: _OptThumbUrlsDict
                                                           success_:
            ^( NSImage* _Nullable _Image, NSURL* _ChosenURL, BOOL _LoadsFromCache )
                {
                NSLog( @"[tms](chosenURL=\U0001F916%@)", _ChosenURL ); // Robot Face

                self.isFetchingInProgres_ = NO;
                self.image_ = _Image;
                self.url_ = _ChosenURL;

                /* The dispatch_semaphore_signal function increments the count variable by 1
                 * to indicate that a resource has been freed up. */
                dispatch_semaphore_signal( sema );

                } failure_: ^( NSError* _Nullable _Errpr )
                    {
                    self.isFetchingInProgres_ = NO;
                    self.error_ = _Errpr;

                    dispatch_semaphore_signal( sema );
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
        NSLog( @"[tms](chosenURL=\U0001F47D%@) disposableFetchingUnit={%@}", self.url_, self ); // Extraterrestrial Alien

        /* dispatch_semaphore_signal( sem ); was invoked by barrier block.
         * "If there are tasks blocked and waiting for a resource,
         * one of them is subsequently unblocked and allowed to do its work." */

        if ( self.image_ && !self.error_ )
            {
            if ( _SuccessHandler )
                _SuccessHandler( self.image_, self.url_, NO );
            }
        else
            {
            if ( _FailureHandler )
                _FailureHandler( self.error_ );
            }
        } );

    if ( !self.hasSetUpGroupNotify_ )
        {
        dispatch_group_notify( self.syncGroup_, dispatch_get_main_queue(), ^{
            NSLog( @"[tms]\U0001F525 disposableFetchingUnit={%@} became discardable", self ); // Emoji: Fire
            self.isDiscardable = YES;

            NSMutableDictionary* userInfoDict = [ NSMutableDictionary dictionary ];
            NSNotification* notif = [ NSNotification notificationWithName: kFetchingUnitBecomeDiscardable object: self userInfo: ( userInfoDict.count > 0 ) ? userInfoDict : nil ];
            [ [ NSNotificationCenter defaultCenter ] postNotification: notif ];
            } );

        self.hasSetUpGroupNotify_ = YES;
        }
    }

#pragma mark - Private

// Writability Swizzling

@synthesize isDiscardable = priIsDiscardable_;
- ( void ) setDiscardable: ( BOOL )_Flag
    {
    if ( !priIsDiscardable_ && _Flag )
        @synchronized( self ) { priIsDiscardable_ = _Flag; }
    else if ( priIsDiscardable_ && !_Flag )
        DDLogUnexpected( @"[tms]discard operation against disposable fetching unit cannot be inversed" );
    }

- ( BOOL ) isDiscardable
    {
    BOOL flag = NO;
    @synchronized( self ) { flag = priIsDiscardable_; }
    return flag;
    }

// Internal

@synthesize fetchingQ_ = priFetchingQ_;
- ( dispatch_queue_t ) fetchingQ_
    {
    if ( !priFetchingQ_ )
        {
        NSString* qLabel = [ NSString stringWithFormat: @"TauMediaService.DisposableFetchingUnit.AsyncFetchingQueue (identifier=%@)", TKNonce() ];
        priFetchingQ_ = dispatch_queue_create( qLabel.UTF8String, DISPATCH_QUEUE_CONCURRENT );
        }

    return priFetchingQ_;
    }

@synthesize syncGroup_ = priSyncGroup_;
- ( dispatch_group_t ) syncGroup_
    {
    if ( !priSyncGroup_ )
        priSyncGroup_ = dispatch_group_create();
    return priSyncGroup_;
    }

@synthesize image_, error_, url_;

@synthesize hasSetUpGroupNotify_ = priHasSetUpGroupNotify_;
- ( void ) setHasSetUpGroupNotify_: ( BOOL )_Flag
    {
    // hasSetUpGroupNotify_ has initial state
    if ( !priHasSetUpGroupNotify_ && _Flag )
        @synchronized( self ) { priHasSetUpGroupNotify_ = _Flag; }
    else if ( priHasSetUpGroupNotify_ && !_Flag )
        DDLogUnexpected( @"[tms]required dispatch_group_notify has been set up, it cannot be inversed" );
    }

- ( BOOL ) hasSetUpGroupNotify_
    {
    BOOL flag = NO;
    @synchronized( self ){ flag = priHasSetUpGroupNotify_; }
    return flag;
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

- ( void ) priFetchPreferredThumbImageFromOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict
                                                   success_: ( void (^)( NSImage* _Image, NSURL* _ChosenURL, BOOL _LoadsFromCache ) )_SuccessHandler
                                                   failure_: ( void (^)( NSError* _Nullable _Errpr ) )_FailureHandler
    {
    NSURL* trialUrl = nil;
    NSString* trialThumbKey = nil;
    NSMutableDictionary* trials = [ _OptThumbUrlsDict mutableCopy ];
    [ self.class getPreferredTrialUrl_: &trialUrl preferredTrialThumbKey_: &trialThumbKey fromOptThumbsUrlDict_: trials ];

    GTMSessionFetcher* fetcher = [ GTMSessionFetcher fetcherWithURL: trialUrl ];
    NSString* fetchID = [ NSString stringWithFormat: @"(fetchID=%@ url=%@)", TKNonce(), trialUrl ];

    [ fetcher setUserData: @{ kSFTrialsUserDataKey : trials
                            , kSFFetchIdUserDataKey : fetchID
                            } ];

    NSLog( @"[tms](initialTriaUrl=\U0001F349%@)", trialUrl ); // Emoji: Watermelon
    [ fetcher beginFetchWithCompletionHandler:
    ^( NSData* _Nullable _Data, NSError* _Nullable _Error )
        {
        if ( _Data && !_Error )
            {
            DDLogDebug( @"[tms]finished fetching thumbnail %@", fetchID );

            NSImage* image = [ [ NSImage alloc ] initWithData: _Data ];
            if ( !image )
                {
                NSError* error = nil;
                error = [ NSError
                    errorWithDomain: TauCentralDataServiceErrorDomain
                               code: TauCentralDataServiceInvalidImageURL
                           userInfo:
                    @{ NSLocalizedDescriptionKey : [ NSString stringWithFormat: @"URL {%@} doesn't point to valid image data.", trialUrl ]
                     , NSLocalizedRecoverySuggestionErrorKey : @"Please specify a valid image URL."
                     } ];

                if ( _FailureHandler )
                    _FailureHandler( error );
                }
            else
                {
                if ( _SuccessHandler )
                    _SuccessHandler( image, [ trialUrl copy ], NO );
                }
            }
        else
            {
            if ( [ _Error.domain isEqualToString: kGTMSessionFetcherStatusDomain ] && ( _Error.code == 404 ) )
                {
                NSMutableDictionary* currentTrails = fetcher.userData[ kSFTrialsUserDataKey ];
                DDLogNotice( @"[tms]404 not found. Couldn't fetch the thumb at {%@} error={%@} comment=%@.\n"
                              "(Attempting to fetch the backing thumbnail...)"
                           , currentTrails[ kPreferredThumbOptKey ]
                           , _Error
                           , fetcher.comment
                           );

                [ currentTrails removeObjectForKey: trialThumbKey ];
                [ self priFetchPreferredThumbImageFromOptThumbUrlsDict_: currentTrails success_: _SuccessHandler failure_: _FailureHandler ];
                }
            else
                if ( _FailureHandler )
                    _FailureHandler( _Error );
            }
        } ];
    }

@end // MediaServiceDisposableFetchingUnit_ class



// ------------------------------------------------------------------------------------------------------------ //



// Private
@interface TauMediaService ()

@property ( strong, readonly ) NSMapTable <NSDictionary <NSString*, NSURL*>*, MediaServiceDisposableFetchingUnit_*>* disposableFetchingUnits_;

// Images Caching

@property ( strong, readonly ) NSCache* imageCache_;

- ( void ) loadCacheForImageNamedUrl_: ( NSURL* )_ImageUrl completionHandler_: ( void ( ^_Nullable )( NSImage* _Nullable _Image ) )_Handeler;
- ( void ) getOptThumbUrlsDict_: ( out NSDictionary <NSString*, NSURL*>* __autoreleasing* _Nonnull )_OptUrlsDictptr fromGTLThumbnailDetails_: ( GTLYouTubeThumbnailDetails* )_ThumbnailDetails;
- ( void ) preferredImageInCacheForOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict dispatchQueue_: ( dispatch_queue_t )_DispatchQueue completionHandler_: ( void ( ^_Nullable )( NSImage* _Image ) )_Handler;

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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [ self preferredImageInCacheForOptThumbUrlsDict_: optThumbUrlsDict
                                      dispatchQueue_: dispatch_get_current_queue()
                                  completionHandler_:
#pragma clang diagnostic pop
    ^( NSImage* _Image )
        {
        if ( _Image )
            {
            if ( _SuccessHandler )
                _SuccessHandler ( _Image, _ThumbnailDetails, YES );
            return;
            }

        MediaServiceDisposableFetchingUnit_* fetchingUnit = nil;
        if ( !( fetchingUnit = [ self.disposableFetchingUnits_ objectForKey: optThumbUrlsDict ] ) )
            {
            NSLog( @"[tms]\U0001F64A is about to create fetching unit for thumbUrlsDict @{%@}", optThumbUrlsDict ); // Emoji: Speak-No-Evil Monkey
            fetchingUnit = [ [ MediaServiceDisposableFetchingUnit_ alloc ] init ];
            [ self.disposableFetchingUnits_ setObject: fetchingUnit forKey: optThumbUrlsDict ];
            }
        else
            NSLog( @"[tms]\U0001F34A %@", optThumbUrlsDict ); // Emoji: Tangerine

        [ fetchingUnit fetchPreferredThumbImageFromOptThumbUrlsDict: optThumbUrlsDict
                                                            success:
        ^( NSImage* _Nullable _ThumbImage, NSURL* _ChosenURL, BOOL _LoadsFromCache )
            {
            NSArray <NSImageRep*>* reps = [ _ThumbImage representations ];
            for ( NSImageRep* _Rep in reps )
                {
                if ( [ _Rep isKindOfClass: [ NSBitmapImageRep class ] ] )
                    {
                    TauPurgeableImageData* cacheData = [ TauPurgeableImageData dataWithData: [ ( NSBitmapImageRep* )_Rep representationUsingType: NSJPEG2000FileType properties: @{} ] ];
                    cacheData.originalUrl = _ChosenURL;
                    [ self.imageCache_ setObject: cacheData forKey: _ChosenURL cost: cacheData.length ];
                    }
                }

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
        } ];
    }

- ( void ) archiveAllMemoryCache
    {
    if ( priImageCache_ )
        [ self.imageCache_ removeAllObjects ];
    }

#pragma mark - Private

@synthesize disposableFetchingUnits_ = priDisposableFetchingUnits_;
- ( NSMapTable <NSDictionary <NSString*, NSURL*>*, MediaServiceDisposableFetchingUnit_*>* ) disposableFetchingUnits_
    {
    if ( !priDisposableFetchingUnits_ )
        {
        priDisposableFetchingUnits_ = [ NSMapTable mapTableWithKeyOptions: NSPointerFunctionsStrongMemory valueOptions: NSPointerFunctionsStrongMemory ];

        [ LRNotificationObserver observeName: kFetchingUnitBecomeDiscardable object: nil owner: self block: ^( NSNotification* _Notif )
            {
            id key = nil;
            for ( id _Key in priDisposableFetchingUnits_ )
                {
                id val = [ priDisposableFetchingUnits_ objectForKey: _Key ];
                if ( val == _Notif.object )
                    {
                    key = _Key;
                    break;
                    }
                }

            [ priDisposableFetchingUnits_ removeObjectForKey: key ];

            NSLog( @"[tms]\U0001F319 %lu", priDisposableFetchingUnits_.count ); // Emoji: Crescent Moon
            } ];
        }

    return priDisposableFetchingUnits_;
    }

// Images Caching

@synthesize imageCache_ = priImageCache_;
- ( NSCache* ) imageCache_
    {
    if ( !priImageCache_ )
        {
        priImageCache_ = [ [ NSCache alloc ] init ];
        [ priImageCache_ setTotalCostLimit: 60 * pow( 1024, 2 ) ];
        [ priImageCache_ setDelegate: self ];
        }

    return priImageCache_;
    }

#pragma mark - Conforms to <NSCacheDelegate>

- ( void ) cache: ( NSCache* )_Cache willEvictObject: ( TauPurgeableImageData* )_Data
    {
    if ( _Cache == priImageCache_ )
        {
        DDLogDebug( @"Archiving to disk" );
        [ TauArchiveService archiveImage: _Data name: _Data.originalUrl.absoluteString dispatchQueue: NULL completionHandler: nil ];
        }
    }

- ( void ) loadCacheForImageNamedUrl_: ( NSURL* )_ImageUrl
                   completionHandler_: ( void ( ^_Nullable )( NSImage* _Nullable _Image ) )_Handler
    {
    NSImage* awakenImage = nil;

    TauPurgeableImageData* cachedData = [ self.imageCache_ objectForKey: _ImageUrl ];

    if ( [ cachedData beginContentAccess ] )
        {
        awakenImage = [ [ NSImage alloc ] initWithData: cachedData ];
        [ cachedData endContentAccess ];

        if ( _Handler )
            _Handler( awakenImage );
        }
    else
        {
        [ TauArchiveService imageArchiveWithImageName: _ImageUrl.absoluteString
                                        dispatchQueue: NULL
                                    completionHandler:
        ^( TauPurgeableImageData* _ImageDat, NSError* _Error )
            {
            NSLog( @"\U00002728 imageLen=%lu <%p>", _ImageDat.length, _ImageDat ); // Emoji: Sparkles

            NSImage* image = nil;
            if ( _ImageDat )
                {
                [ self.imageCache_ setObject: _ImageDat forKey: _ImageUrl cost: _ImageDat.length ];
                image = [ [ NSImage alloc ] initWithData: _ImageDat ];
                }

            if ( _Handler )
                _Handler( image );
            } ];
        }
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
        DDLogUnexpected( @"[tms]Coundn't find out the preferred thumbnail from {%@}.", preferredThumbnail );
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
        DDLogUnexpected( @"[tms]urls dict I/O argument didn't get polulated from {%@}.", _ThumbnailDetails );
    }

- ( void ) preferredImageInCacheForOptThumbUrlsDict_: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict
                                      dispatchQueue_: ( dispatch_queue_t )_DispatchQueue
                                  completionHandler_: ( void ( ^_Nullable )( NSImage* _Image ) )_Handler
    {
    NSURL* trialUrl = nil;
    NSString* trialThumbKey = nil;
    NSMutableDictionary* trails = [ _OptThumbUrlsDict mutableCopy ];
    [ MediaServiceDisposableFetchingUnit_ getPreferredTrialUrl_: &trialUrl preferredTrialThumbKey_: &trialThumbKey fromOptThumbsUrlDict_: trails ];

    [ self loadCacheForImageNamedUrl_: trialUrl
                   completionHandler_:
    ^( NSImage* _Nullable _Image )
        {
        if ( _Image )
            {
            if ( _Handler )
                {
                dispatch_queue_t q = _DispatchQueue ?: dispatch_get_main_queue();
                dispatch_async( q, ( dispatch_block_t )^{ _Handler( _Image ); } );
                }
            }
        else
            {
            if ( trails.count > 0 )
                {
                [ trails removeObjectForKey: trialThumbKey ];
                [ self preferredImageInCacheForOptThumbUrlsDict_: trails dispatchQueue_: _DispatchQueue completionHandler_: _Handler ];
                }
            else
                {
                if ( _Handler )
                    {
                    dispatch_queue_t q = _DispatchQueue ?: dispatch_get_main_queue();
                    dispatch_async( q, ( dispatch_block_t )^{ _Handler( nil ); } );
                    }
                }
            }
        } ];
    }

@end // TauMediaService class