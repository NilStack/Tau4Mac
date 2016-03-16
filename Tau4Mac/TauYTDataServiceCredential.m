//
//  TauYTDataServiceCredential.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauYTDataServiceCredential.h"
#import "PriTauYTDataServiceCredential_.h"

// Private Interfaces
@interface TauYTDataServiceCredential ()

// Prepare for copying
@property ( copy, readwrite ) NSString* identifier;
@property ( assign, readwrite ) uint64_t consumerFingerprint;

@end // Private Interfaces

// TauYTDataServiceCredential class
@implementation TauYTDataServiceCredential
    {
    NSString __strong* id_;

    uint64_t fingerprint_;
    TauYTDataServiceConsumptionType consumptionType_;
    NSMethodSignature __strong* applyingMethodSig_;
    }

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return NO;
    }

@dynamic consumerFingerprint;
@dynamic identifier;
@dynamic applyingMethodSignature;

@synthesize maxResultPerPage;

- ( uint64_t ) consumerFingerprint
    {
    return fingerprint_;
    }

- ( NSString* ) identifier
    {
    return id_;
    }

- ( NSMethodSignature* ) applyingMethodSignature
    {
    return applyingMethodSig_;
    }

#pragma mark - Conforms to <NSCopying>

- ( instancetype ) copyWithZone: ( NSZone* )_Zone
    {
    TauYTDataServiceCredential* copy =
        [ [ TauYTDataServiceCredential alloc ] initWithConsumer: nil applyingMethodSignature: applyingMethodSig_ consumptionType: consumptionType_ ];

    copy.identifier = id_;
    copy.consumerFingerprint = fingerprint_;

    return copy;
    }

#pragma mark - Comparing

- ( BOOL ) isEqualToCredential: ( TauYTDataServiceCredential* )_Rhs
    {
    if ( self == _Rhs )
        return YES;

    return [ self.identifier isEqualToString: _Rhs.identifier ];
    }

- ( BOOL ) isEqual: ( id )_Object
    {
    if ( self == _Object )
        return YES;

    if ( [ _Object isKindOfClass: [ TauYTDataServiceCredential class ] ] )
        return [ self isEqualToCredential: ( TauYTDataServiceCredential* )_Object ];

    return [ super isEqual: _Object ];
    }

@end // TauYTDataServiceCredential class

// TauYTDataServiceCredential + PriTau_
@implementation TauYTDataServiceCredential ( PriTau_ )

- ( instancetype ) initWithConsumer: ( id )_Consumer applyingMethodSignature: ( NSMethodSignature* )_Sig consumptionType: ( TauYTDataServiceConsumptionType )_Type
    {
    if ( !_Sig )
        {
        DDLogUnexpected( @"Failed to initialize: signature parameters must not be nil" );
        return nil;
        }

    if ( self = [ super init ] )
        {
        id_ = [ TKNonce() copy ];

        consumptionType_ = _Type;

        fingerprint_ = ( uint64_t )_Consumer;
        applyingMethodSig_ = _Sig;
        }

    return self;
    }

@end // TauYTDataServiceCredential + PriTau_