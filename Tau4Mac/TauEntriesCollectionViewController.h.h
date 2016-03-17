//
//  TauEntriesCollectionViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

@class TauResultCollectionPanelViewController;

// TauEntriesCollectionViewController class
@interface TauEntriesCollectionViewController : NSViewController <NSCollectionViewDelegate, NSCollectionViewDataSource>

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject ticket: ( GTLServiceTicket* )_Ticket;

#pragma mark - Properties

@property ( strong, readwrite ) GTLCollectionObject* ytCollectionObject;
@property ( strong, readwrite ) GTLServiceTicket* ytTicket;

@end // TauEntriesCollectionViewController class