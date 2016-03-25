//
//  TauSearchResultsCollectionContentSubViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionViewController.h"
#import "TauAbstractCollectionContentSubViewController.h"

// TauSearchResultsCollectionContentSubViewController class
@interface TauSearchResultsCollectionContentSubViewController : TauAbstractCollectionContentSubViewController
    <TauYTDataServiceConsumer, TauContentCollectionViewRelayDataSource>

@property ( strong, readwrite ) NSString* searchText;   // KVB compliant

@property ( assign, readonly ) BOOL hasPrev;    // KVB compliant
@property ( assign, readonly ) BOOL hasNext;    // KVB compliant
@property ( assign, readonly ) BOOL isPaging;   // KVB compliant

@property ( strong, readonly ) NSString* searchResultsSummaryText;  // KVB compliant

#pragma mark - Actions

- ( IBAction ) loadPrevPageAction: ( id )_Sender;
- ( IBAction ) loadNextPageAction: ( id )_Sender;

- ( IBAction ) cancelAction: ( id )_Sender;

@end // TauSearchResultsCollectionContentSubViewController class