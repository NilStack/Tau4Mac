//
//  TauSearchResultsCollectionContentSubViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractContentSubViewController.h"

// TauSearchResultsCollectionContentSubViewController class
@interface TauSearchResultsCollectionContentSubViewController : TauAbstractContentSubViewController <TauYTDataServiceConsumer>

@property ( strong, readwrite ) NSString* searchContent;

@end // TauSearchResultsCollectionContentSubViewController class