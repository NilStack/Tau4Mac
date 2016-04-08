//
//  TauAbstractCollectionContentSubViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/25/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionViewController.h"
#import "TauAbstractContentSubViewController.h"

// TauAbstractCollectionContentSubViewController class
@interface TauAbstractCollectionContentSubViewController : TauAbstractContentSubViewController
    <TauAPIServiceConsumer, TauContentCollectionViewRelayDataSource>

#pragma mark - UI

@property ( strong, readonly ) TauContentCollectionViewController* contentCollectionViewController;

#pragma mark - External KVB Compliant Properties

@property ( assign, readonly ) BOOL hasPrev;    // KVB compliant
@property ( assign, readonly ) BOOL hasNext;    // KVB compliant
@property ( assign, readonly ) BOOL isPaging;   // KVB compliant

#pragma mark - Prefer to be Overrided by Concrete Classes

@property ( strong, readonly ) NSString* resultsSummaryText;    // KVB compliant
@property ( strong, readonly ) NSString* appWideSummaryText;    // KVB compliant

#pragma mark - TDS Related

//@property ( weak, readonly ) NSArray <GTLObject*>* results;    // KVB compliant
@property ( weak, readonly ) TauAbstractResultCollection* results;    // KVB compliant
@property ( strong, readwrite ) id originalOperationsCombination;

#pragma mark - Actions

- ( IBAction ) loadPrevPageAction: ( id )_Sender;
- ( IBAction ) loadNextPageAction: ( id )_Sender;

@end // TauAbstractCollectionContentSubViewController class