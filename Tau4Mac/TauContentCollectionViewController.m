//
//  TauContentCollectionViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionViewController.h"
#import "TauContentCollectionItem.h"
#import "TauNormalWrappedLayout.h"

@interface TauContentCollectionViewController ()
@property ( weak ) IBOutlet NSCollectionView* contentCollectionView_;
@end

@implementation TauContentCollectionViewController

#pragma mark - Initializations

NSString static* const kContentCollectionItemID = @"kContentCollectionItemID";

- ( void ) viewDidLoad
    {
    [ [ self.view configureForAutoLayout ] setWantsLayer: YES ];

    [ self.contentCollectionView_ registerClass: [ TauContentCollectionItem class ] forItemWithIdentifier: kContentCollectionItemID ];
    [ self.contentCollectionView_ setCollectionViewLayout: [ [ TauNormalWrappedLayout alloc ] init ] ];
    }

#pragma mark - Conforms to <NSCollectionViewDataSource>

- ( NSInteger ) numberOfSectionsInCollectionView: ( NSCollectionView* )_CollectionView
    {
    return 1;
    }

- ( NSInteger ) collectionView: ( NSCollectionView* )_CollectionView numberOfItemsInSection: ( NSInteger )_Section
    {
//    if ( ![ self.relayDataSource respondsToSelector: @selector( collectionViewRequiredData: ) ] )
    return [ [ self.relayDataSource collectionViewRequiredData: self ] count ];
    }

- ( NSCollectionViewItem* ) collectionView: ( NSCollectionView* )_CollectionView itemForRepresentedObjectAtIndexPath: ( NSIndexPath* )_IndexPath
    {
    NSCollectionViewItem* item = [ _CollectionView makeItemWithIdentifier: kContentCollectionItemID forIndexPath: _IndexPath ];
    item.representedObject = [ [ self.relayDataSource collectionViewRequiredData: self ] objectAtIndex: [ _IndexPath item ] ];
    return item;
    }

- ( void ) reloadData
    {
    [ self.contentCollectionView_ reloadData ];
    }

#pragma mark - Conforms to <NSCollectionViewDelegate>
// TODO:

#pragma mark - Conforms to <NSCollectionViewDelegateFlowLayout>
// TODO: Customize flow layout of collection view


@end
