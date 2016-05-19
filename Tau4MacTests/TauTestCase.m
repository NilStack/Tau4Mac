//
//  TauTestCase.m
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "TauTestCase.h"

// TauTestCase class
@implementation TauTestCase

#pragma mark - Initializations

- ( void ) setUp
    {
    [ super setUp ];


    /* 
    Valid Channel identifiers:

    UCqhnX4jA0A5paNd1v-zEysw        UClwg08ECyHnm_RzY1wnZC1A        UC15_JWyO0xsrV-W-pYdFtBQ        UCTs-d2DgyuJVRICivxe2Ktg        UCse-sH9XJlKIbtD3y-bch7w
    UCQMle4QI2zJuOI5W5TOyOcQ        UCPGBPIwECAUJON58-F2iuFA        UC7dLLOOzmcrYyNmIKBq1XjQ        UCHt_A74xM2Hs5L5otMhhQFw        UChqor0VU2yKWnCtXryIzOiw
    UCimi6e990VyqpwC0zy90nmw        UCltg-E5fsQ97p-tgRj1JRqg        UCEKjWYp5HDxNxSHWx8LjBpA        UCE1RYoDi0e3Aef6wzT_wa9w        UC8J2bNpe0Wbwa4KaXO8Otkw
    UClAAWwt6FA_T5xHCDXneIEQ        UCoeusq4FSPM5bZd5THdHHjg        UCclPhe1o4WK_UbrIfnpADoQ        UC19Pe9y2Zotf4mygqt_7qdA        UCKf4K7AElixicoBMdNAKoLQ
    */

    channelIdentifiersSample0 = @[ @"UCqhnX4jA0A5paNd1v-zEysw", @"UClwg08ECyHnm_RzY1wnZC1A", @"UC15_JWyO0xsrV-W-pYdFtBQ", @"UCTs-d2DgyuJVRICivxe2Ktg", @"UCse-sH9XJlKIbtD3y-bch7w", @"UCQMle4QI2zJuOI5W5TOyOcQ", @"UCPGBPIwECAUJON58-F2iuFA", @"UC7dLLOOzmcrYyNmIKBq1XjQ" ];
    channelIdentifiersSample1 = @[ @"UCHt_A74xM2Hs5L5otMhhQFw", @"UChqor0VU2yKWnCtXryIzOiw", @"UCimi6e990VyqpwC0zy90nmw", @"UCltg-E5fsQ97p-tgRj1JRqg", @"UCEKjWYp5HDxNxSHWx8LjBpA", @"UCE1RYoDi0e3Aef6wzT_wa9w", @"UC8J2bNpe0Wbwa4KaXO8Otkw", @"UClAAWwt6FA_T5xHCDXneIEQ" ];
    channelIdentifiersSample2 = nil;
    channelIdentifiersSample3 = @[];
    channelIdentifiersSample4 = @[ @"", @"" ];

    
    }

#pragma mark - Unit Test Samples

@synthesize channelIdentifiersSample0, channelIdentifiersSample1, channelIdentifiersSample2, channelIdentifiersSample3, channelIdentifiersSample4;
@synthesize playlistIdentifiersSample0, playlistIdentifiersSample1, playlistIdentifiersSample2, playlistIdentifiersSample3, playlistIdentifiersSample4;
@synthesize playlistItemIdentifiersSample0, playlistItemIdentifiersSample1, playlistItemIdentifiersSample2, playlistItemIdentifiersSample3, playlistItemIdentifiersSample4;
@synthesize videoIdentifiersSample0, videoIdentifiersSample1, videoIdentifiersSample2, videoIdentifiersSample3, videoIdentifiersSample4;

#pragma mark - Testing

#define POS_TEST_METHOD_MARKER @"_pos"
#define NEG_TEST_METHOD_MARKER @"_neg"

+ ( BOOL ) isTestMethodPositive: ( SEL )_TestMethodSel
    {
    NSString* selString = NSStringFromSelector( _TestMethodSel );
    return [ [ selString substringWithRange: NSMakeRange( selString.length - POS_TEST_METHOD_MARKER.length - 1, POS_TEST_METHOD_MARKER.length ) ] isEqualToString: POS_TEST_METHOD_MARKER ];
    }

+ ( BOOL ) isTestMethodNegative: ( SEL )_TestMethodSel
    {
    NSString* selString = NSStringFromSelector( _TestMethodSel );
    return [ [ selString substringWithRange: NSMakeRange( selString.length - NEG_TEST_METHOD_MARKER.length - 1, NEG_TEST_METHOD_MARKER.length ) ] isEqualToString: NEG_TEST_METHOD_MARKER ];
    }

@end // TauTestCase class