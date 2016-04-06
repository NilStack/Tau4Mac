//
//  NSBundle+Tau.m
//  Tau4Mac
//
//  Created by Tong G. on 4/6/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauAppIntrospection.h"

// Private
@interface NSBundle ( TauAppIntrospectionPri_ )

- ( SecRequirementRef ) cfGetReq_;
- ( SecStaticCodeRef ) cfCreateStaticBundleCode_;

@end // Private

// NSBundle + TauAppIntrospection
@implementation NSBundle ( TauAppIntrospection )

@dynamic comesFromMacAppStore;
- ( BOOL ) comesFromMacAppStore
    {
    NSURL* appStoreReceiptURL = [ self appStoreReceiptURL ];
    NSFileManager* fileManager = [ [ NSFileManager alloc ] init ];
    BOOL appStoreReceiptExists = [ fileManager fileExistsAtPath: [ appStoreReceiptURL path ] ];
    return appStoreReceiptExists;
    }

@dynamic isSandboxed;
- ( BOOL ) isSandboxed
    {
    BOOL flag = NO;
    OSStatus resultCode = errSecSuccess;

    SecStaticCodeRef staticCode = [ self cfCreateStaticBundleCode_ ];
    SecRequirementRef sandboxRequirement = [ self cfGetReq_ ];
    if ( staticCode && sandboxRequirement )
        {
        resultCode = SecStaticCodeCheckValidityWithErrors( staticCode, kSecCSBasicValidateOnly, sandboxRequirement, NULL );
        if ( resultCode == errSecSuccess )
            flag = YES;

        CFRelease( staticCode );
        }

    return flag;
    }

@end // NSBundle + TauAppIntrospection

// Private
@implementation NSBundle ( TauAppIntrospectionPri_ )

- ( SecRequirementRef ) cfGetReq_
    {
    SecRequirementRef static sReq = NULL;

    if ( !sReq )
        {
        OSStatus resultCode = errSecSuccess;
        NSString* reqPredicates = @"entitlement[\"com.apple.security.app-sandbox\"] exists";
        resultCode = SecRequirementCreateWithString( ( __bridge CFStringRef )reqPredicates, kSecCSDefaultFlags, &sReq );
        if ( resultCode != errSecSuccess )
            DDLogUnexpected( @"Failed creating the additional requirement for the req predicates: %@", reqPredicates );
        }

    return sReq;
    }

- ( SecStaticCodeRef ) cfCreateStaticBundleCode_
    {
    OSStatus resultCode = errSecSuccess;
    SecStaticCodeRef staticCode = NULL;

    resultCode = SecStaticCodeCreateWithPath( ( __bridge CFURLRef )[ self bundleURL ], kSecCSDefaultFlags, &staticCode );
    if ( resultCode != errSecSuccess )
        DDLogUnexpected( @"Failed creating the static code for the bundle %@", self );

    return staticCode;
    }

@end // Private