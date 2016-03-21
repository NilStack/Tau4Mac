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
    // Do view setup here.
    }

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ ( TauContentCollectionItemView* )( self.view ) setYtContent: _RepresentedObject ];
    }

#pragma mark - Overrides for Selection and Highlighting Support

- ( void ) setHighlightState: ( NSCollectionViewItemHighlightState )_NewHighlightState
    {
    [ super setHighlightState: _NewHighlightState ];
    
    // Relay the newHighlightState to our AAPLSlideCarrierView.
    // [(AAPLSlideCarrierView *)[self view] setHighlightState:newHighlightState];
    }

- ( void ) setSelected: ( BOOL )_Selected
    {
    [ super setSelected: _Selected ];

    // Relay the new "selected" state to our AAPLSlideCarrierView.
    [ ( TauContentCollectionItem* )[ self view ] setSelected: _Selected ];
    }

@end // TauContentCollectionItem class