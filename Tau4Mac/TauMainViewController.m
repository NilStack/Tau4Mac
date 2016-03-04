//
//  TauMainViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauMainViewController.h"
#import "TauContentPanelViewController.h"

// TauMainViewController class
@implementation TauMainViewController

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
        NSBundle* correctBundle = [ NSBundle bundleForClass: [ TauContentPanelViewController class ] ];
        TauContentPanelViewController* contentPanelViewController = [ [ TauContentPanelViewController alloc ] initWithNibName: nil bundle: correctBundle ];

        [ self.view removeConstraints: self.view.constraints ];
        [ self.view setSubviews: @[] ];
        [ self.view addSubview: contentPanelViewController.view ];
        [ contentPanelViewController.view autoPinEdgesToSuperviewEdges ];

        GTLQueryYouTube* ytSearchListQuery = [ GTLQueryYouTube queryForSearchListWithPart: @"snippet" ];
        [ ytSearchListQuery setQ: userInput ];
        [ ytSearchListQuery setMaxResults: 20 ];
//        [ ytSearchListQuery setType: @"video" ];

        [ [ TauDataService sharedService ].ytService executeQuery: ytSearchListQuery
                                                completionHandler:
            ^( GTLServiceTicket* _Ticket, GTLYouTubeSearchListResponse* _SearchListResp, NSError* _Error )
                {
                if ( !_Error )
                    [ contentPanelViewController setRepresentedObject: _SearchListResp ];
                else
                    DDLogError( @"%@", _Error );
                } ];
        }
    }

@end // TauMainViewController class