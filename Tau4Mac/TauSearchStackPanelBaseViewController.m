//
//  TauSearchStackPanelBaseViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/5/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauSearchStackPanelBaseViewController.h"
#import "TauResultCollectionPanelViewController.h"
#import "TauAbstractStackPanelController.h"

// Private Interfaces
@interface TauSearchStackPanelBaseViewController ()

@end // Private Interfaces

// TauSearchStackPanelBaseViewController class
@implementation TauSearchStackPanelBaseViewController
    {
@private
    GTLServiceTicket __strong* ytSearchListTicket_;
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

        NSString* typeString = nil;
        if ( self.videoRadioButton.state )
            typeString = @"video";
        else if ( self.playlistRadioButton.state )
            typeString = @"playlist";
        else if ( self.channelRadioButton.state )
            typeString = @"channel";

        if ( typeString )
            [ ytSearchListQuery setType: typeString ];

        if ( ytSearchListTicket_ )
            [ ytSearchListTicket_ cancelTicket ];

        ytSearchListTicket_ = [ [ TauDataService sharedService ].ytService executeQuery: ytSearchListQuery
                                                                      completionHandler:
        ^( GTLServiceTicket* _Ticket, GTLYouTubeSearchListResponse* _SearchListResp, NSError* _Error )
            {
            if ( !_Error )
                {
                TauResultCollectionPanelViewController* contentPanelViewController =
                    [ [ TauResultCollectionPanelViewController alloc ] initWithGTLCollectionObject: _SearchListResp ticket: _Ticket ];

                [ contentPanelViewController setHostStack: self.hostStack ];
                [ self.hostStack pushView: contentPanelViewController ];

                DDLogInfo( @"%@", ytSearchListTicket_ );
                }
            else
                DDLogError( @"%@", _Error );
            } ];
        }
    }

- ( IBAction ) radioSwitchedAction: ( NSButton* )_Sender
    {
    DDLogDebug( @"Radio was switched by %@ (%@ state:%ld)", _Sender, _Sender.title, _Sender.state );
    }

- ( void ) cleanUp
    {
    self.searchField.stringValue = @"";
    }

@end // TauSearchStackPanelBaseViewController class