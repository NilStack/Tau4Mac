//
//  TauResultCollectionPanelViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAbstractStackViewItem.h"

@class TauResultsCollectionToolbar;

// TauResultCollectionPanelViewController class
@interface TauResultCollectionPanelViewController : TauAbstractStackViewItem

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject ticket: ( GTLServiceTicket* )_Ticket;

#pragma mark - Properties

@property ( strong, readwrite ) GTLCollectionObject* ytCollectionObject;
@property ( strong, readwrite ) GTLServiceTicket* ytTicket;

#pragma mark - IBAction

- ( IBAction ) pageAction: ( id )_Sender;
- ( IBAction ) dismissAction: ( id )_Sender;

@end // TauResultCollectionPanelViewController class