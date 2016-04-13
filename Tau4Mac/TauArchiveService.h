//
//  TauArchiveService.h
//  Tau4Mac
//
//  Created by Tong G. on 4/13/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauArchiveService class
@interface TauArchiveService : NSObject

+ ( void ) imageArchiveWithImageName: ( NSString* )_ImageName completionHandler: ( void (^)( NSImage* _Image, NSError* _Error ) )_Handler;

@end // TauArchiveService class