//
//  TauMediaService.h
//  Tau4Mac
//
//  Created by Tong G. on 4/8/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// MediaServiceDisposableFetchingUnit_ class
@interface MediaServiceDisposableFetchingUnit_ : NSObject

@property ( assign, readonly, atomic ) BOOL isDiscardable;

- ( void ) fetchPreferredThumbImageFromOptThumbUrlsDict: ( NSDictionary <NSString*, NSURL*>* )_OptThumbUrlsDict
                                                success: ( void (^)( NSImage* _Image, NSURL* _ChosenURL, BOOL _LoadsFromCache ) )_SuccessHandler
                                                failure: ( void (^)( NSError* _Errpr ) )_FailureHandler;
@end

// TauMediaService class
@interface TauMediaService : NSObject <NSCacheDelegate>

#pragma mark - Singleton Instance

+ ( instancetype ) sharedService;

#pragma mark - Remote Image & Video Fetching

- ( void ) fetchPreferredThumbnailFrom: ( GTLYouTubeThumbnailDetails* )_Thumbnails
                               success: ( void (^)( NSImage* _Image, GTLYouTubeThumbnailDetails* _ThumbnailDetails, BOOL _LoadsFromCache ) )_SuccessHandler
                               failure: ( void (^)( NSError* _Error ) )_FailureHandler;

@end // TauMediaService class