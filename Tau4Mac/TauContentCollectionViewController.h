//
//  TauContentCollectionViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@protocol TauContentCollectionViewRelayDataSource;

// TauContentCollectionViewController class
@interface TauContentCollectionViewController : NSViewController
    <NSCollectionViewDataSource, NSCollectionViewDelegate, NSCollectionViewDelegateFlowLayout>

@property ( weak ) IBOutlet id <TauContentCollectionViewRelayDataSource> relayDataSource;

- ( void ) reloadData;

@end // TauContentCollectionViewController class

// TauContentCollectionViewRelayDataSource protocol
@protocol TauContentCollectionViewRelayDataSource <NSObject>

@required
- ( NSArray <GTLObject*>* ) collectionViewRequiredData: ( TauContentCollectionViewController* )_Controller;

@end // TauContentCollectionViewRelayDataSource protocol