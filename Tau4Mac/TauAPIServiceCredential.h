//
//  TauAPIServiceCredential.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauAPIServiceCredential class
@interface TauAPIServiceCredential : NSObject <NSCopying>

@property ( assign, readonly ) TauAPIServiceConsumptionType consumptionType;

@property ( assign, readonly ) uint64_t consumerFingerprint;
@property ( copy, readonly ) NSString* identifier;
@property ( strong, readonly ) NSMethodSignature* applyingMethodSignature;

#pragma mark - Comparing

- ( BOOL ) isEqualToCredential: ( TauAPIServiceCredential* )_Rhs;

@end // TauAPIServiceCredential class