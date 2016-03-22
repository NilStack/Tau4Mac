//
//  PriTauYTDataServiceCredential.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYTDataServiceCredential.h"

// TauYTDataServiceCredential + PriTau_
@interface TauYTDataServiceCredential ( PriTau_ )
- ( instancetype ) initWithConsumer: ( id )_Consumer applyingMethodSignature: ( NSMethodSignature* )_Sig consumptionType: ( TauYTDataServiceConsumptionType )_Type;

// Prepare for copying
@property ( copy, readwrite ) NSString* identifier;
@property ( assign, readwrite ) uint64_t consumerFingerprint;

@end // TauYTDataServiceCredential + PriTau_