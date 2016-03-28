//
//  TauExploreTabControl.h
//  Tau4Mac
//
//  Created by Tong G. on 3/28/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauExploreTabControl class
@interface TauExploreTabControl : NSView

#pragma mark - External KVB Compliant Properties

@property ( assign, readwrite ) TauExploreSubTabTag activedTabTag;  // KVB-compliant

#pragma mark - Actions

- ( IBAction ) tabsSwitchedAction: ( id )_Sender;

@end // TauExploreTabControl class