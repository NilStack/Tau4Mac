//
//  TauContentCollectionViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionViewController.h"
#import "TauContentInspectorViewController.h"
#import "TauContentCollectionItem.h"
#import "TauNormalWrappedLayout.h"

// Private
@interface TauContentCollectionViewController ()

@property ( weak ) IBOutlet NSCollectionView* contentCollectionView_;

@property ( weak ) IBOutlet NSSplitViewController* splitViewController_;

// Wrapped guys above in xib for ease the feed of self.splitViewController_ (instance of NSSplitViewController)
@property ( strong, readonly ) NSSplitViewItem* contentCollectionSplitViewItem_;
@property ( strong, readonly ) NSSplitViewItem* contentInspectorSplitViewItem_;

// Feeding the split view items above
@property ( weak ) IBOutlet NSViewController* wrapperOfContentCollectionView_;
@property ( weak ) IBOutlet TauContentInspectorViewController* wrapperOfContentInspectorView_;

@end // Private



// ------------------------------------------------------------------------------------------------------------ //



// TauContentCollectionViewController class
@implementation TauContentCollectionViewController

TauDealloc( ^{ [ self.wrapperOfContentInspectorView_ unbind: TAU_KEY_OF_SEL( @selector( ytContents ) ) ]; } );

#pragma mark - Initializations

NSString static* const kContentCollectionItemID = @"kContentCollectionItemID";

- ( void ) viewDidLoad
    {
    // Registering for data source of collection view
    [ self.contentCollectionView_ registerClass: [ TauContentCollectionItem class ] forItemWithIdentifier: kContentCollectionItemID ];
    [ self.contentCollectionView_ setCollectionViewLayout: [ [ TauNormalWrappedLayout alloc ] init ] ];

    // Embeding the split view controller
    // Required setting up done in the IB Identity insepector
    NSSplitViewController* splitViewController = self.splitViewController_;
    [ splitViewController addSplitViewItem: self.contentCollectionSplitViewItem_ ];
    [ splitViewController addSplitViewItem: self.contentInspectorSplitViewItem_ ];

    [ self addChildViewController: splitViewController ];
    [ self.view addSubview: [ splitViewController.view configureForAutoLayout ] ];
    [ splitViewController.view autoPinEdgesToSuperviewEdges ];

    [ self.wrapperOfContentInspectorView_
            bind: TAU_KEY_OF_SEL( @selector( ytContents ) )
        toObject: self
     withKeyPath: TAU_KEY_OF_SEL( @selector( selectedItems ) )
         options: nil ];
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

@dynamic selectedItems;
+ ( NSSet <NSString*>* ) keyPathsForValuesAffectingSelectedItems
    {
    return [ NSSet setWithObjects: TAU_KEY_OF_SEL( @selector( selectionIndexPaths ) ), nil ];
    }

// In order to produce an unique array,
// result array will be derived from an internal ordered set,
- ( NSArray <NSCollectionViewItem*>* ) selectedItems
    {
    NSMutableOrderedSet* result = nil;

    NSArray* relayedDataModel = [ self.relayDataSource contentCollectionViewRequiredData: self ];

    NSSet <NSIndexPath*>* newIndexPaths = self.selectionIndexPaths;

    // Extracting the corresponding model items
    // FIXME: this implementation should take into account both the sections and indexes within an index path
    for ( NSIndexPath* _IndexPath in newIndexPaths )
        {
        NSRange indexRange = NSMakeRange( 0, _IndexPath.length );
        NSUInteger* indexesBuffer = malloc( sizeof ( NSUInteger ) * indexRange.length );
        [ _IndexPath getIndexes: indexesBuffer range: NSMakeRange( 0, indexRange.length ) ];

        for ( int _Index = 0; _Index < indexRange.length; _Index++ )
            {
            if ( _Index == ( indexRange.length - 1 ) )
                {
                // Lazy initialization
                if ( !result )
                    result = [ NSMutableOrderedSet orderedSet ];

                [ result addObject: [ relayedDataModel objectAtIndex: indexesBuffer[ _Index ] ] ];
                }
            }

        free( indexesBuffer );
        }

    return result ? [ result array ] : @[];
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

#pragma mark - Private

@synthesize contentCollectionSplitViewItem_ = priContentCollectionSplitViewItem_;
@synthesize contentInspectorSplitViewItem_ = priContentInspectorSplitViewItem_;

- ( NSSplitViewItem* ) contentCollectionSplitViewItem_
    {
    if ( !priContentCollectionSplitViewItem_ )
        {
        priContentCollectionSplitViewItem_ = [ NSSplitViewItem splitViewItemWithViewController: self.wrapperOfContentCollectionView_ ];
        [ priContentCollectionSplitViewItem_ setCanCollapse: NO ];

        //
        [ priContentCollectionSplitViewItem_ setMinimumThickness: TauNormalWrappedLayoutItemWidth + 65.f ];
        }

    return priContentCollectionSplitViewItem_;
    }

- ( NSSplitViewItem* ) contentInspectorSplitViewItem_
    {
    if ( !priContentInspectorSplitViewItem_ )
        {
        priContentInspectorSplitViewItem_ = [ NSSplitViewItem contentListWithViewController: self.wrapperOfContentInspectorView_ ];
        [ priContentInspectorSplitViewItem_ setCanCollapse: YES ];

        //
        [ priContentInspectorSplitViewItem_ setMaximumThickness: 600.f ];
        [ priContentInspectorSplitViewItem_ setMinimumThickness:
            TAU_APP_MIN_WIDTH - self.contentCollectionSplitViewItem_.minimumThickness - self.splitViewController_.splitView.dividerThickness ];
        }

    return priContentInspectorSplitViewItem_;
    }

@end // TauContentCollectionViewController class