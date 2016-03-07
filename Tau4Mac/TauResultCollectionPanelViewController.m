//
//  TauResultCollectionPanelViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauResultCollectionPanelViewController.h"
#import "TauYouTubeEntriesCollectionViewController.h"
#import "TauPanelStackViewController.h"
#import "TauSearchResultCollectionToolbar.h"

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

#define TAU_PAGEER_PREV 0
#define TAU_PAGEER_NEXT 1

// To suppress the "PerformSelector may cause a leak because its selector is unknown" warning
#define TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING( _CodeFragment )\
    _Pragma("clang diagnostic push")\
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
        do { _CodeFragment } while( 0 )\
    _Pragma("clang diagnostic pop")

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
            TAU_SUPPRESS_PERFORM_SELECTOR_LEAK_WARNING( pageToken = [ ytCollectionObject_ performSelector: pageSelector ]; );

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

@end // TauResultCollectionPanelViewController class