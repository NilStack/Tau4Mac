//
//  TauResultCollectionPanelViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauResultCollectionPanelViewController.h"
#import "TauYouTubeEntriesCollectionViewController.h"
#import "TauSearchPanelStackViewController.h"

// Private Interfaces
@interface TauResultCollectionPanelViewController ()

@end // Private Interfaces

// TauResultCollectionPanelViewController class
@implementation TauResultCollectionPanelViewController
    {
    TauYouTubeEntriesCollectionViewController __strong* entriesCollectionViewController_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject
                                        ticket: ( GTLServiceTicket* )_Ticket
    {
    if ( self = [ super initWithNibName: nil bundle: nil ] )
        entriesCollectionViewController_ =
            [ [ TauYouTubeEntriesCollectionViewController alloc ] initWithGTLCollectionObject: _CollectionObject ticket: _Ticket ];

    return self;
    }

- ( void ) viewDidLoad
    {
    [ self.view configureForAutoLayout ];

    [ self.view addSubview: entriesCollectionViewController_.view ];
    [ entriesCollectionViewController_.view autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsMake( 0, 0, 0, 0 ) excludingEdge: ALEdgeTop ];
    [ entriesCollectionViewController_.view autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: self.toolbarView ];
    }

#pragma mark - IBAction

- ( IBAction ) dismissAction: ( id )_Sender
    {
    [ self.hostStack popView ];
    }

@end // TauResultCollectionPanelViewController class