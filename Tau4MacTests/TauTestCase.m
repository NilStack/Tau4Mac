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

    /* valid search Qs: */
    searchQSample0 = @[ @"gopro", @"github", @"Google", @"MICROSOFT", @"APple", @"張國榮", @"じえいたい" ];
    searchQSample1 = @[ @"서울", @"काठमाडौं, काठमान्डु", @"བོད་རང་སྐྱོང་ལྗོངས།", @"دولت عالیه عثمانیه", @"微软公司", @"ביבליה", @"香港" ];
    searchQSample2 = nil;
    searchQSample3 = @[];
    searchQSample4 = @[ @"", @"" ];

    /* valid channel identifiers:

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

    /* valid video identifiers:
    
    4DSNJ_WvfN4     GgutlKV42SY     eF2QhJjCaDc     NepG36wz9H8     UcoS9aQItgA
    CoLpsD0gGik     zjrfMgFOb9Y     Jrtn5nBM3Dw     XVfOe5mFbAE     AIPsaGGgTRc
    Bl0qM_U5kBU     3JPRjROC0SQ     mM1P41qeVGs     7BY1WccX_Is     RWxqSEMXWuw
    v9OpAewxljc     wo-ygJTQRPw     kxLY59nH5cI     7d59O6cfaM0     rAOISmMmloo
    */

    videoIdentifiersSample0 = @[ @"4DSNJ_WvfN4", @"GgutlKV42SY", @"eF2QhJjCaDc", @"NepG36wz9H8", @"UcoS9aQItgA" ];
    videoIdentifiersSample1 = @[ @"CoLpsD0gGik", @"zjrfMgFOb9Y", @"Jrtn5nBM3Dw", @"XVfOe5mFbAE", @"AIPsaGGgTRc" ];
    videoIdentifiersSample2 = nil;
    videoIdentifiersSample3 = @[];
    videoIdentifiersSample4 = @[ @"", @"" ];

    /* valid playlist item identifiers:
    
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4xMkVGQjNCMUM1N0RFNEUx    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41MjE1MkI0OTQ2QzJGNzNG
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4yODlGNEE0NkRGMEEzMEQy    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41NkI0NEY2RDEwNTU3Q0M2
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4wOTA3OTZBNzVEMTUzOTMy    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41MzJCQjBCNDIyRkJDN0VD
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC5DQUNERDQ2NkIzRUQxNTY1    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC45NDk1REZENzhEMzU5MDQz
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC5GNjNDRDREMDQxOThCMDQ2    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC40NzZCMERDMjVEN0RFRThB
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC5EMEEwRUY5M0RDRTU3NDJC    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC45ODRDNTg0QjA4NkFBNkQy
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4zMDg5MkQ5MEVDMEM1NTg2    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41Mzk2QTAxMTkzNDk4MDhF
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC5EQUE1NTFDRjcwMDg0NEMz    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41QTY1Q0UxMTVCODczNThE
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4yMUQyQTQzMjRDNzMyQTMy    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC45RTgxNDRBMzUwRjQ0MDhC
    UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC5ENDU4Q0M4RDExNzM1Mjcy    sUEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4yMDhBMkNBNjRDMjQxQTg1
    */

    playlistItemIdentifiersSample0 =
        @[ @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4xMkVGQjNCMUM1N0RFNEUx", @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41MjE1MkI0OTQ2QzJGNzNG"
         , @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4yODlGNEE0NkRGMEEzMEQy", @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41NkI0NEY2RDEwNTU3Q0M2"
         , @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4wOTA3OTZBNzVEMTUzOTMy", @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41MzJCQjBCNDIyRkJDN0VD"
         , @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC5DQUNERDQ2NkIzRUQxNTY1", @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC45NDk1REZENzhEMzU5MDQz"
         ];

    playlistItemIdentifiersSample1 =
        @[ @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC5GNjNDRDREMDQxOThCMDQ2", @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC40NzZCMERDMjVEN0RFRThB"
         , @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC5EMEEwRUY5M0RDRTU3NDJC", @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC45ODRDNTg0QjA4NkFBNkQy"
         , @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC4zMDg5MkQ5MEVDMEM1NTg2", @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41Mzk2QTAxMTkzNDk4MDhF"
         , @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC5EQUE1NTFDRjcwMDg0NEMz", @"UEwwbG85TU9CZXRFSEJNNFotbFk3UzNMajdpZkdRTTQyRC41QTY1Q0UxMTVCODczNThE"
         ];

    playlistItemIdentifiersSample2 = nil;
    playlistItemIdentifiersSample3 = @[];
    playlistItemIdentifiersSample4 = @[ @"", @"" ];

    /* valid playlist identifiers:
    
    PL1N57mwBHtN1co-Qt5FPejAhqg-dgwOIC  PLzj7TwUeMQ3i1QJ6-Z91KRjFg5dzacD1O  PL2Qq6_3SVp4NWceaoN_VuR9ml1BQAbHxQ  PLw2HD3prgOu3OpnVqwkoAS4y9KIlqaAXW  PLzj7TwUeMQ3jkkDD_N-nRHQTp9oX7Smam
    PLDTQLSdym9HjUHGZ1pHJDiEGbVMhM__TE  PLhKFRV3-UgpeA_3wzRHF8AS8T7ppKvm9O  PLXPr7gfUMmKyE22-YpbgcDfr2SXEO7-qX  PLPie5drlGW25NnMjef7HRdSAqEjxz66Ky  PLEC59ED056A5F1C58
    PL2Qq6_3SVp4P4N0Wyusc_-256lXZ3DVsw  PLKyhCiyLgYYFD5Xo6SXEYvEm_fBUzsOZD  PLIqQdbkf_WOuRBAHjxf3K0OouAjOWM5pq  PL2Qq6_3SVp4MmX8WoCJsQM_LI8qQ75Get  PLsSecSBtcB6DFvb0XSPY9hLwtBRK4FX-o
    PLYMOUCVo86jEeMMdaaq03jQ_t9nFV737s  PLA315AFCD23B50347                  PLtvjQSgFXE1ciL7S-GW-K4tCxa_RoK-ZK  PLyQFNhZCWRn8IkyqeXCNE8lOik4ueRC7j  PL890E75C547F8AABB
    */

    playlistIdentifiersSample0 = @[ @"PL1N57mwBHtN1co-Qt5FPejAhqg-dgwOIC", @"PLzj7TwUeMQ3i1QJ6-Z91KRjFg5dzacD1O", @"PL2Qq6_3SVp4NWceaoN_VuR9ml1BQAbHxQ", @"PLw2HD3prgOu3OpnVqwkoAS4y9KIlqaAXW", @"PLzj7TwUeMQ3jkkDD_N-nRHQTp9oX7Smam" ];
    playlistIdentifiersSample1 = @[ @"PLDTQLSdym9HjUHGZ1pHJDiEGbVMhM__TE", @"PLhKFRV3-UgpeA_3wzRHF8AS8T7ppKvm9O", @"PLXPr7gfUMmKyE22-YpbgcDfr2SXEO7-qX", @"PLPie5drlGW25NnMjef7HRdSAqEjxz66Ky", @"PLEC59ED056A5F1C58" ];
    playlistIdentifiersSample2 = nil;
    playlistIdentifiersSample3 = @[];
    playlistIdentifiersSample4 = @[ @"", @"" ];
    }

#pragma mark - Unit Test Samples

@synthesize searchQSample0, searchQSample1, searchQSample2, searchQSample3, searchQSample4;
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