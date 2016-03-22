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
// NSIndexPath + Tau
@interface NSIndexPath ( Tau )
@property ( copy, readonly ) NSIndexSet* indexSetRep;
@end // NSIndexPath + Tau

@implementation NSIndexPath ( Tau )

@dynamic indexSetRep;
- ( NSIndexSet* ) indexSetRep
    {
//    NSUInteger length = self.length;
    return nil;
    }

@end

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

#pragma mark - Relay the Model Data

// Relay the model data from hosting content view controller to the internal collection view

- ( void ) reloadData
    {
    [ self.contentCollectionView_ reloadData ];
    }

#pragma mark - Relay the Controllers & Views State

@dynamic selectionIndexPaths;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingSelectionIndexPaths
    {
    return [ NSSet setWithObjects: @"contentCollectionView_.selectionIndexPaths", nil ];
    }

- ( NSSet <NSIndexPath*>* ) selectionIndexPaths
    {
    return self.contentCollectionView_.selectionIndexPaths;
    }

- ( void ) setSelectionIndexPaths: ( NSSet <NSIndexPath*>* )_New
    {
    [ self.contentCollectionView_ setSelectionIndexPaths: _New ];
    }

#pragma mark - Conforms to <NSCollectionViewDataSource>

- ( NSInteger ) numberOfSectionsInCollectionView: ( NSCollectionView* )_CollectionView
    {
    return 1;
    }

- ( NSInteger ) collectionView: ( NSCollectionView* )_CollectionView numberOfItemsInSection: ( NSInteger )_Section
    {
    return [ [ self.relayDataSource contentCollectionViewRequiredData: self ] count ];
    }

- ( NSCollectionViewItem* ) collectionView: ( NSCollectionView* )_CollectionView itemForRepresentedObjectAtIndexPath: ( NSIndexPath* )_IndexPath
    {
    NSCollectionViewItem* item = [ _CollectionView makeItemWithIdentifier: kContentCollectionItemID forIndexPath: _IndexPath ];
    item.representedObject = [ [ self.relayDataSource contentCollectionViewRequiredData: self ] objectAtIndex: [ _IndexPath item ] ];
    return item;
    }

#pragma mark - Conforms to <NSCollectionViewDelegate>
// TODO:

#pragma mark - Conforms to <NSCollectionViewDelegateFlowLayout>
// TODO: Customize flow layout of collection view


#pragma mark - Conforms to <NSSplitViewDelegate>

- ( BOOL ) splitView: ( NSSplitView* )_SplitView shouldAdjustSizeOfSubview: ( NSView* )_Subview
    {
    return NO;
    }

@end
