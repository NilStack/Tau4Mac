//
//  TauAPIServiceCredential.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAPIServiceCredential.h"
#import "PriTauAPIServiceCredential_.h"

// Private Interfaces
@interface TauAPIServiceCredential ()
@end // Private Interfaces

// TauAPIServiceCredential class
@implementation TauAPIServiceCredential
    {
    TauAPIServiceConsumptionType consumptionType_;

    NSString __strong* id_;

    uint64_t fingerprint_;
    NSMethodSignature __strong* applyingMethodSig_;
    }

+ ( BOOL ) accessInstanceVariablesDirectly
    {
    return NO;
    }

@dynamic consumptionType;
@dynamic consumerFingerprint;
@dynamic identifier;
@dynamic applyingMethodSignature;

- ( TauAPIServiceConsumptionType ) consumptionType
    {
    return consumptionType_;
    }

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
    TauAPIServiceCredential* copy =
        [ [ TauAPIServiceCredential alloc ] initWithConsumer: nil applyingMethodSignature: applyingMethodSig_ consumptionType: consumptionType_ ];

    copy.identifier = id_;
    copy.consumerFingerprint = fingerprint_;

    return copy;
    }

#pragma mark - Comparing

- ( BOOL ) isEqualToCredential: ( TauAPIServiceCredential* )_Rhs
    {
    if ( self == _Rhs )
        return YES;

    BOOL isEqual = [ self.identifier isEqualToString: _Rhs.identifier ];
    return isEqual;
    }

- ( BOOL ) isEqual: ( id )_Object
    {
    if ( self == _Object )
        return YES;

    if ( [ _Object isKindOfClass: [ TauAPIServiceCredential class ] ] )
        return [ self isEqualToCredential: ( TauAPIServiceCredential* )_Object ];

    return [ super isEqual: _Object ];
    }

#pragma mark - Degbugging

- ( NSString* ) description
    {
    return [ NSString stringWithFormat: @"Credential %p {id:%@ consumptionType:%ld consumerFingerprint:%llu applyingMethodSig:%@}"
                                      , self, self.identifier, self.consumptionType, self.consumerFingerprint, self.applyingMethodSignature ];
    }

@end // TauAPIServiceCredential class

// TauAPIServiceCredential + PriTau_
@implementation TauAPIServiceCredential ( PriTau_ )

@dynamic identifier;
@dynamic consumerFingerprint;

- ( void ) setIdentifier: ( NSString* )_New
    {
    if ( id_ != _New )
        id_ = [ _New copy ];
    }

- ( void ) setConsumerFingerprint: ( uint64_t )_New
    {
    if ( fingerprint_ != _New )
        fingerprint_ = _New;
    }


- ( instancetype ) initWithConsumer: ( id )_Consumer applyingMethodSignature: ( NSMethodSignature* )_Sig consumptionType: ( TauAPIServiceConsumptionType )_Type
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

@end // TauAPIServiceCredential + PriTau_