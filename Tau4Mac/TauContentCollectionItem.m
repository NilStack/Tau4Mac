//
//  TauContentCollectionItem.m
//  Tau4Mac
//
//  Created by Tong G. on 3/20/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentCollectionItem.h"
#import "TauContentCollectionItemView.h"

// Private
@interface TauContentCollectionItem ()

@end // Private

// TauContentCollectionItem class
@implementation TauContentCollectionItem

- ( void ) viewDidLoad
    {
    [ super viewDidLoad ];
    }

TauDeallocBegin
TauDeallocEnd

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ ( TauContentCollectionItemView* )( self.view ) setYtContent: _RepresentedObject ];
    }

#pragma mark - Events

// When a content collection item is double-clicked
- ( void ) mouseDown: ( NSEvent* )_Event
    {
    if ( _Event.clickCount == 2 )
        {
        GTLObject* ytContent = [ ( TauContentCollectionItemView* )( self.view ) ytContent ];

        switch ( [ ( TauContentCollectionItemView* )( self.view ) type ] )
            {
            case TauYouTubePlayList:
                {
                NSString* playlistId = ytContent.JSON[ @"id" ][ @"playlistId" ];
                [ [ NSNotificationCenter defaultCenter ] postNotificationName: TauShouldExposeContentCollectionItemNotif object: self.collectionView userInfo: @{ kPlaylistIdentifier : playlistId } ];
                } break;

            case TauYouTubeUnknownContent:
                {
                DDLogUnexpected( @"Encountered unknown content collection item type" );
                } break;
            }
        }
    else
        [ super mouseDown: _Event ];
    }

#pragma mark - Overrides for Selection and Highlighting Support

- ( void ) setHighlightState: ( NSCollectionViewItemHighlightState )_NewHighlightState
    {
    [ super setHighlightState: _NewHighlightState ];

    // Relay the newHighlightState to our TauContentCollectionItem.
     [ ( TauContentCollectionItem* )[ self view ] setHighlightState: _NewHighlightState];
    }

- ( void ) setSelected: ( BOOL )_Selected
    {
    [ super setSelected: _Selected ];

    // Relay the new "selected" state to our TauContentCollectionItem.
    [ ( TauContentCollectionItem* )[ self view ] setSelected: _Selected ];
    }

@end // TauContentCollectionItem class