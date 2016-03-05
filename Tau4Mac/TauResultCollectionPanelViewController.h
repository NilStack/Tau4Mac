//
//  TauResultCollectionPanelViewController.h
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauStackViewItem.h"

@interface TauResultCollectionPanelViewController : TauStackViewItem

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject ticket: ( GTLServiceTicket* )_Ticket;

#pragma mark - IBAction

- ( IBAction ) cancelAction: ( id )_Sender;

@end
