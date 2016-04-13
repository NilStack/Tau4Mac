//
//  TauArchiveService.h
//  Tau4Mac
//
//  Created by Tong G. on 4/13/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauPurgeableImageData;

// TauArchiveService class
@interface TauArchiveService : NSObject

+ ( void ) archiveImage: ( TauPurgeableImageData* )_ImageDat
                   name: ( NSString* )_ImageName
          dispatchQueue: ( dispatch_queue_t )_DispatchQueue
      completionHandler: ( void (^)( NSError* _Error ) )_Handler;

+ ( void ) imageArchiveWithImageName: ( NSString* )_ImageName
                       dispatchQueue: ( dispatch_queue_t )_DispatchQueue
                   completionHandler: ( void (^)( TauPurgeableImageData* _ImageDat, NSError* _Error ) )_Handler;

@end // TauArchiveService class