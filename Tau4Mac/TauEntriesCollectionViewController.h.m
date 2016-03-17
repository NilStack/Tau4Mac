//
//  TauEntriesCollectionViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauEntriesCollectionViewController.h.h"
#import "TauResultCollectionPanelViewController.h"
#import "TauEntriesCollectionViewItem.h"

#import "TauCollectionObject.h"
#import "TauYouTubeEntryView.h"

// Private Interfaces
@interface TauEntriesCollectionViewController ()
@end // Private Interfaces

// TauEntriesCollectionViewController class
@implementation TauEntriesCollectionViewController
    {
@protected
    GTLCollectionObject __strong* ytCollectionObject_;
    GTLServiceTicket __strong* ytTicket_;
    }

#pragma mark - Initializations

#define TAU_ROW_COUNT 5
#define TAU_COL_COUNT 4

#define TAU_ROW_MAX_IDX ( TAU_ROW_COUNT - 1 )
#define TAU_COL_MAX_IDX ( TAU_COL_COUNT - 1 )

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject ticket: ( GTLServiceTicket* )_Ticket
    {
    NSBundle* correctBundle = [ NSBundle bundleForClass: [ TauEntriesCollectionViewController class ] ];
    
    if ( self = [ super initWithNibName: nil bundle: correctBundle ] )
        {
        ytCollectionObject_ = _CollectionObject;
        ytTicket_ = _Ticket;
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ self setRepresentedObject: ytCollectionObject_ ];

    [ ( ( NSCollectionView* )self.view ) registerClass: [ TauEntriesCollectionViewItem class ] forItemWithIdentifier: @"tau-entry" ];
    }

#pragma mark - Conforms to <NSCollectionViewDataSource>

- ( NSInteger ) numberOfSectionsInCollectionView: ( NSCollectionView* )_CollectionView
    {
    return 1;
    }

- ( NSInteger ) collectionView:(NSCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {
    return self.ytCollectionObject.items.count;
    }

- ( NSCollectionViewItem* ) collectionView:(NSCollectionView *)collectionView itemForRepresentedObjectAtIndexPath:(NSIndexPath *)indexPath
    {
    NSCollectionViewItem* item = [ collectionView makeItemWithIdentifier: @"tau-entry" forIndexPath: indexPath ];
    item.representedObject = [ self.ytCollectionObject.items objectAtIndex: [ indexPath item ] ];

    return item;
    }

#pragma mark - Dynamic Properties

@dynamic ytCollectionObject;
@dynamic ytTicket;

- ( void ) setYtCollectionObject: ( GTLCollectionObject* )_CollectionObject
    {
    if ( ytCollectionObject_ != _CollectionObject )
        {
        ytCollectionObject_ = _CollectionObject;
        [ self setRepresentedObject: ytCollectionObject_ ];
        }
    }

- ( GTLCollectionObject* ) ytCollectionObject
    {
    return ytCollectionObject_;
    }

- ( void ) setYtTicket: ( GTLServiceTicket* )_Ticket
    {
    if ( ytTicket_ != _Ticket )
        ytTicket_ = _Ticket;
    }

- ( GTLServiceTicket* ) ytTicket
    {
    return ytTicket_;
    }

@end // TauEntriesCollectionViewController class