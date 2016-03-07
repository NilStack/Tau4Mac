//
//  TauResultCollectionPanelViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauResultCollectionPanelViewController.h"
#import "TauYouTubeEntriesCollectionViewController.h"
#import "TauAbstractStackPanelController.h"
#import "TauResultsCollectionToolbar.h"

// Private Interfaces
@interface TauResultCollectionPanelViewController ()

@end // Private Interfaces

// TauResultCollectionPanelViewController class
@implementation TauResultCollectionPanelViewController
    {
    TauYouTubeEntriesCollectionViewController __strong* entriesCollectionViewController_;
    
    GTLCollectionObject __strong* ytCollectionObject_;
    GTLServiceTicket __strong* ytTicket_;
    }

#pragma mark - Initializations

- ( instancetype ) initWithGTLCollectionObject: ( GTLCollectionObject* )_CollectionObject
                                        ticket: ( GTLServiceTicket* )_Ticket
    {
    if ( self = [ super initWithNibName: nil bundle: nil ] )
        {
        ytCollectionObject_ = _CollectionObject;
        ytTicket_ = _Ticket;

        entriesCollectionViewController_ =
            [ [ TauYouTubeEntriesCollectionViewController alloc ] initWithGTLCollectionObject: ytCollectionObject_ ticket: _Ticket ];
        }

    return self;
    }

- ( void ) viewDidLoad
    {
    [ self.view configureForAutoLayout ];

    [ self.view addSubview: entriesCollectionViewController_.view ];
    [ entriesCollectionViewController_.view autoPinEdgesToSuperviewEdgesWithInsets: NSEdgeInsetsZero excludingEdge: ALEdgeTop ];
    [ entriesCollectionViewController_.view autoPinEdge: ALEdgeTop toEdge: ALEdgeBottom ofView: self.toolbarView ];

    self.toolbarView.ytCollectionObject = ytCollectionObject_;
    }

#pragma mark - IBAction

- ( IBAction ) pageAction: ( NSSegmentedControl* )_Sender
    {
    id pageToken = nil;
    SEL pageSelector = nil;

    switch ( _Sender.selectedSegment )
        {
        case TAU_PAGEER_PREV:
            {
            pageSelector = @selector( prevPageToken );
            } break;

        case TAU_PAGEER_NEXT:
            {
            pageSelector = @selector( nextPageToken );
            } break;
        }

    @try {
        if ( [ ytCollectionObject_ respondsToSelector: pageSelector ] )
            TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING( pageToken = [ ytCollectionObject_ performSelector: pageSelector ] );

        if ( pageToken )
            {
            GTLQueryYouTube* newQuery = ytTicket_.originalQuery;
            newQuery.pageToken = pageToken;

            ytTicket_ = [ [ TauDataService sharedService ].ytService
                executeQuery: newQuery completionHandler:
            ^( GTLServiceTicket* _Ticket, GTLCollectionObject* _CollectionObject, NSError* _Error )
                {
                if ( _CollectionObject && !_Error )
                    {
                    ytCollectionObject_ = _CollectionObject;
                    ytTicket_ = _Ticket;

                    entriesCollectionViewController_.ytCollectionObject = ytCollectionObject_;
                    entriesCollectionViewController_.ytTicket = ytTicket_;

                    self.toolbarView.ytCollectionObject = _CollectionObject;
                    }
                else
                    DDLogError( @"%@", _Error );
                } ];
            }
        } @catch ( NSException* _Ex )
            {
            DDLogWarn( @"%@", _Ex );
            };
    }

- ( IBAction ) dismissAction: ( id )_Sender
    {
    [ self.hostStack popView ];
    }

#pragma mark - Dynamic Properties

@dynamic ytCollectionObject;
@dynamic ytTicket;

- ( void ) setYtCollectionObject: ( GTLCollectionObject* )_CollectionObject
    {
    if ( ytCollectionObject_ != _CollectionObject )
        {
        ytCollectionObject_ = _CollectionObject;
        entriesCollectionViewController_.ytCollectionObject = ytCollectionObject_;

        self.toolbarView.ytCollectionObject = ytCollectionObject_;
        }
    }

- ( GTLCollectionObject* ) ytCollectionObject
    {
    return ytCollectionObject_;
    }

- ( void ) setYtTicket: ( GTLServiceTicket* )_Ticket
    {
    if ( ytTicket_ != _Ticket )
        {
        ytTicket_ = _Ticket;
        entriesCollectionViewController_.ytTicket = ytTicket_;
        }
    }

- ( GTLServiceTicket* ) ytTicket
    {
    return ytTicket_;
    }

@end // TauResultCollectionPanelViewController class