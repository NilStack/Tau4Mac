//
//  GTLObject+Tau.h
//  Tau4Mac
//
//  Created by Tong G. on 3/27/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// GTLObject + Tau
@interface GTLObject ( Tau )

@property ( assign, readonly ) TauYouTubeContentType tauContentType;
@property ( copy, readonly ) NSString* tauEssentialIdentifier;
@property ( copy, readonly ) NSString* tauEssentialTitle;
@property ( copy, readonly ) NSURL* urlOnWebsite;

- ( void ) exposeMeOnBahalfOf: ( id )_Sender;

@end // GTLObject + Tau