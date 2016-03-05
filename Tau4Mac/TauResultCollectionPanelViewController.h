//
//  TauResultCollectionPanelViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauStackViewItem.h"

// TauResultCollectionPanelViewController class
@interface TauResultCollectionPanelViewController : TauStackViewItem

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject ticket: ( GTLServiceTicket* )_Ticket;

#pragma mark - Outlets

@property ( weak ) IBOutlet NSView* toolbarView;

#pragma mark - IBAction

- ( IBAction ) dismissAction: ( id )_Sender;

@end // TauResultCollectionPanelViewController class