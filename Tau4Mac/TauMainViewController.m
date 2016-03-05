//
//  TauMainViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainViewController.h"
#import "TauYouTubeEntriesCollectionViewController.h"

// TauMainViewController class
@implementation TauMainViewController
    {
@private
    GTLServiceTicket __strong* ytSearchListTicket_;
    }

#pragma mark - Initializations

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];

    // Do any additional setup after loading the view.
    [ self.view setFrameSize: NSMakeSize( 800, 800 ) ];
    }

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    // Update the view, if already loaded.
    }

#pragma mark - IBActions

- ( IBAction ) searchUserInputAction: ( id )_Sender
    {
    NSString* userInput = self.searchField.stringValue;
    if ( userInput.length > 0 )
        {
        GTLQueryYouTube* ytSearchListQuery = [ GTLQueryYouTube queryForSearchListWithPart: @"snippet" ];
        [ ytSearchListQuery setQ: userInput ];
        [ ytSearchListQuery setMaxResults: 20 ];
//        [ ytSearchListQuery setType: @"playlist" ];

        if ( ytSearchListTicket_ )
            [ ytSearchListTicket_ cancelTicket ];

        ytSearchListTicket_ = [ [ TauDataService sharedService ].ytService executeQuery: ytSearchListQuery
                                                                      completionHandler:
        ^( GTLServiceTicket* _Ticket, GTLYouTubeSearchListResponse* _SearchListResp, NSError* _Error )
            {
            if ( !_Error )
                {
                TauYouTubeEntriesCollectionViewController* contentPanelViewController =
                    [ [ TauYouTubeEntriesCollectionViewController alloc ] initWithGTLCollectionObject: _SearchListResp ticket: _Ticket ];

                [ self.view removeConstraints: self.view.constraints ];
                [ self.view setSubviews: @[] ];
                [ self.view addSubview: contentPanelViewController.view ];
                [ contentPanelViewController.view autoPinEdgesToSuperviewEdges ];

                DDLogInfo( @"%@", ytSearchListTicket_ );
                }
            else
                DDLogError( @"%@", _Error );
            } ];
        }
    }

@end // TauMainViewController class