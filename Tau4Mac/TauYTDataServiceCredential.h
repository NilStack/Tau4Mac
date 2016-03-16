//
//  TauYTDataServiceCredential.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

// TauYTDataServiceCredential class
@interface TauYTDataServiceCredential : NSObject <NSCopying>

@property ( assign, readonly ) TauYTDataServiceConsumptionType consumptionType;

@property ( assign, readonly ) uint64_t consumerFingerprint;
@property ( copy, readonly ) NSString* identifier;
@property ( strong, readonly ) NSMethodSignature* applyingMethodSignature;

@property ( assign, readwrite ) NSUInteger maxResultPerPage;

#pragma mark - Comparing

- ( BOOL ) isEqualToCredential: ( TauYTDataServiceCredential* )_Rhs;

@end // TauYTDataServiceCredential class