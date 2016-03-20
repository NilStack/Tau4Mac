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

@property ( assign, readonly ) BOOL hasPrev;    // KVB compliant
@property ( assign, readonly ) BOOL hasNext;    // KVB compliant
@property ( assign, readonly ) BOOL isPaging;   // KVB compliant

#pragma mark - Actions

- ( IBAction ) loadPrevPageAction: ( id )_Sender;
- ( IBAction ) loadNextPageAction: ( id )_Sender;

- ( IBAction ) cancelAction: ( id )_Sender;

@end // TauSearchResultsCollectionContentSubViewController class