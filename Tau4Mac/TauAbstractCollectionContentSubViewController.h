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
    <TauYTDataServiceConsumer, TauContentCollectionViewRelayDataSource>
    {
@protected
    NSDictionary __strong* originalOperationsCombination_;
    }

@property ( assign, readonly ) BOOL hasPrev;    // KVB compliant
@property ( assign, readonly ) BOOL hasNext;    // KVB compliant
@property ( assign, readonly ) BOOL isPaging;   // KVB compliant

@property ( weak, readwrite ) NSArray <GTLObject*>* results;

@property ( strong, readonly ) TauContentCollectionViewController* contentCollectionViewController;

#pragma mark - Overrides by Concrete Classes

@property ( strong, readonly ) NSString* resultsSummaryText;  // KVB compliant

#pragma mark - Actions

- ( IBAction ) loadPrevPageAction: ( id )_Sender;
- ( IBAction ) loadNextPageAction: ( id )_Sender;

- ( IBAction ) cancelAction: ( id )_Sender;

@end // TauAbstractCollectionContentSubViewController class