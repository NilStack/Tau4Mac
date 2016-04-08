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

- ( void ) fetchImageWithURL: ( NSURL* )_URL success: ( void (^)( NSImage* _Image ) )_SuccessHandler failure: ( void (^)( NSError* _Error ) )_FailureHandler;

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