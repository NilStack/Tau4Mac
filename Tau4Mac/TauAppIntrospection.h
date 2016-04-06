//
//  NSBundle+Tau.h
//  Tau4Mac
//
//  Created by Tong G. on 4/6/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// NSBundle + TauAppIntrospection
@interface NSBundle ( TauAppIntrospection )

@property ( assign, readonly ) BOOL comesFromMacAppStore;
@property ( assign, readonly ) BOOL isSandboxed;

@end // NSBundle + TauAppIntrospection