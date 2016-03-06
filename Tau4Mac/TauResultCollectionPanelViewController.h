//
//  TauResultCollectionPanelViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauStackViewItem.h"

@class TauResultCollectionToolbarView;

// TauResultCollectionPanelViewController class
@interface TauResultCollectionPanelViewController : TauStackViewItem

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject ticket: ( GTLServiceTicket* )_Ticket;

#pragma mark - Outlets

@property ( weak ) IBOutlet NSScrollView* scrollView;
@property ( weak ) IBOutlet TauResultCollectionToolbarView* toolbarView;

#pragma mark - IBAction

- ( IBAction ) pageAction: ( id )_Sender;
- ( IBAction ) dismissAction: ( id )_Sender;

@end // TauResultCollectionPanelViewController class