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

@property ( strong, readonly ) NSButton* controlInspectorButton;
@property ( assign, readwrite ) BOOL inspectorCollapsed;

#pragma mark - Relay the Model Data

// Relay the model data from hosting content view controller to the internal collection view

@property ( weak ) IBOutlet id <TauContentCollectionViewRelayDataSource> relayDataSource;
- ( void ) reloadData;

#pragma mark - Relay the Controllers & Views State

@property ( copy ) NSSet <NSIndexPath*>* selectionIndexPaths;    // KVB-Compliant
@property ( strong, readonly ) NSArray <NSCollectionViewItem*>* selectedItems;  // KVO-Compliant

@end // TauContentCollectionViewController class



// ------------------------------------------------------------------------------------------------------------ //



// TauContentCollectionViewRelayDataSource protocol
@protocol TauContentCollectionViewRelayDataSource <NSObject>

@required
- ( TauAbstractResultCollection* ) contentCollectionViewRequiredData: ( TauContentCollectionViewController* )_Controller;

@end // TauContentCollectionViewRelayDataSource protocol



// ------------------------------------------------------------------------------------------------------------ //



// TauAccessoryBarContentCollectionSummaryView class
@interface TauAccessoryBarContentCollectionSummaryView : NSView
@end // TauAccessoryBarContentCollectionSummaryView class