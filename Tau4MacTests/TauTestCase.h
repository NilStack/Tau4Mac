//
//  TauTestCase.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#define TAU_UNITTEST_SAMPLES_COUNT 15

#define GENERATE_POS_SAMPLE ( TYPE, NAME, NUMBER ) \


// TauTestCase class
@interface TauTestCase : XCTestCase

#pragma mark - Unit Test Samples

@property ( strong, readonly ) NSArray <NSString*>* channelIdentifiersSample0, channelIdentifiersSample1, channelIdentifiersSample2, channelIdentifiersSample3, channelIdentifiersSample4;
@property ( strong, readonly ) NSArray <NSString*>* playlistIdentifiersSample0, playlistIdentifiersSample1, playlistIdentifiersSample2, playlistIdentifiersSample3, playlistIdentifiersSample4;
@property ( strong, readonly ) NSArray <NSString*>* playlistItemIdentifiersSample0, playlistItemIdentifiersSample1, playlistItemIdentifiersSample2, playlistItemIdentifiersSample3, playlistItemIdentifiersSample4;
@property ( strong, readonly ) NSArray <NSString*>* videoIdentifiersSample0, videoIdentifiersSample1, videoIdentifiersSample2, videoIdentifiersSample3, videoIdentifiersSample4;

#pragma mark - Testing

+ ( BOOL ) isTestMethodPositive: ( SEL )_TestMethodSel;
+ ( BOOL ) isTestMethodNegative: ( SEL )_TestMethodSel;

@end // TauTestCase class