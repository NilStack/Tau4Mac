//
//  TauEntriesCollectionViewItem.m
//  Tau4Mac
//
//  Created by Tong G. on 3/17/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauEntriesCollectionViewItem.h"
#import "TauYouTubeEntryView.h"

// Private Interfaces
@interface TauEntriesCollectionViewItem ()

@end // Private Interfaces

// TauEntriesCollectionViewItem class
@implementation TauEntriesCollectionViewItem

- ( void ) setRepresentedObject:(id)representedObject
    {
    [ ( TauYouTubeEntryView* )( self.view ) setYtContent: representedObject ];
    }

@end // TauEntriesCollectionViewItem class