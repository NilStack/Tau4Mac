//
//  TauExploreSegmentControl.h
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauExploreSegmentControl class
@interface TauExploreSegmentControl : NSView

@property ( assign, readwrite ) TauExploreSubTabTag activedTabTag;  // KVB-compliant

@property ( weak ) IBOutlet NSButton* MeTubeRecessedButton;
@property ( weak ) IBOutlet NSButton* subscriptionsRecessedButton;

#pragma mark - Actions

- ( IBAction ) tabsSwitchedAction: ( id )_Sender;

@end // TauExploreSegmentControl class