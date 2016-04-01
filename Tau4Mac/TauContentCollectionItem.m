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

TauDeallocBegin
TauDeallocEnd

#pragma mark - Overrides

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ ( TauContentCollectionItemView* )( self.view ) setYouTubeContent: _RepresentedObject ];
    }

#pragma mark - Events

// When a content collection item is double-clicked
- ( void ) mouseDown: ( NSEvent* )_Event
    {
    if ( _Event.clickCount == 2 )
        {
        GTLObject* ytContent = [ ( TauContentCollectionItemView* )( self.view ) YouTubeContent ];
        [ ytContent exposeMeOnBahalfOf: self.collectionView ];
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