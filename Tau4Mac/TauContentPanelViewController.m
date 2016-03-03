//
//  TauContentPanelViewController.m
//  Tau4Mac
//
//  Created by Tong G. on 3/3/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauContentPanelViewController.h"

#import "TauCollectionObject.h"

// Private Interfaces
@interface TauContentPanelViewController ()
@end // Private Interfaces

// TauContentPanelViewController class
@implementation TauContentPanelViewController
    {
@protected
    GTLCollectionObject __strong* repContents_;
    }

#pragma mark - Initializations

- ( void ) setRepresentedObject: ( id )_RepresentedObject
    {
    [ super setRepresentedObject: _RepresentedObject ];

    DDLogDebug( @"%@", [ TauDataService sharedService ].signedInUsername );
    }

// #pragma mark - Private Interfaces

@end // TauContentPanelViewController class