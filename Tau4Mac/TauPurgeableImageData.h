//
//  TauPurgeableImageData.h
//  Tau4Mac
//
//  Created by Tong G. on 4/9/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauPurgeableImageData class
@interface TauPurgeableImageData : NSPurgeableData

@property ( copy, readwrite, atomic ) NSURL* originalUrl;

@end // TauPurgeableImageData class