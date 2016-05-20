//
//  TauTestCase.h
//  Tau4Mac
//
//  Created by Tong G. on 3/16/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#define TAU_UNITTEST_SAMPLES_COUNT 15

// TauTestCase class
@interface TauTestCase : XCTestCase

#pragma mark - Unit Test Samples

@property ( strong, readonly ) NSArray <NSString*>* searchQSample0;
@property ( strong, readonly ) NSArray <NSString*>* searchQSample1;
@property ( strong, readonly ) NSArray <NSString*>* searchQSample2;
@property ( strong, readonly ) NSArray <NSString*>* searchQSample3;
@property ( strong, readonly ) NSArray <NSString*>* searchQSample4;

@property ( strong, readonly ) NSArray <NSString*>* channelIdentifiersSample0;
@property ( strong, readonly ) NSArray <NSString*>* channelIdentifiersSample1;
@property ( strong, readonly ) NSArray <NSString*>* channelIdentifiersSample2;
@property ( strong, readonly ) NSArray <NSString*>* channelIdentifiersSample3;
@property ( strong, readonly ) NSArray <NSString*>* channelIdentifiersSample4;

@property ( strong, readonly ) NSArray <NSString*>* playlistIdentifiersSample0;
@property ( strong, readonly ) NSArray <NSString*>* playlistIdentifiersSample1;
@property ( strong, readonly ) NSArray <NSString*>* playlistIdentifiersSample2;
@property ( strong, readonly ) NSArray <NSString*>* playlistIdentifiersSample3;
@property ( strong, readonly ) NSArray <NSString*>* playlistIdentifiersSample4;

@property ( strong, readonly ) NSArray <NSString*>* playlistItemIdentifiersSample0;
@property ( strong, readonly ) NSArray <NSString*>* playlistItemIdentifiersSample1;
@property ( strong, readonly ) NSArray <NSString*>* playlistItemIdentifiersSample2;
@property ( strong, readonly ) NSArray <NSString*>* playlistItemIdentifiersSample3;
@property ( strong, readonly ) NSArray <NSString*>* playlistItemIdentifiersSample4;

@property ( strong, readonly ) NSArray <NSString*>* videoIdentifiersSample0;
@property ( strong, readonly ) NSArray <NSString*>* videoIdentifiersSample1;
@property ( strong, readonly ) NSArray <NSString*>* videoIdentifiersSample2;
@property ( strong, readonly ) NSArray <NSString*>* videoIdentifiersSample3;
@property ( strong, readonly ) NSArray <NSString*>* videoIdentifiersSample4;

@property ( strong, readonly ) NSArray <NSString*>* subscriptionIdentifiersSample0;
@property ( strong, readonly ) NSArray <NSString*>* subscriptionIdentifiersSample1;
@property ( strong, readonly ) NSArray <NSString*>* subscriptionIdentifiersSample2;
@property ( strong, readonly ) NSArray <NSString*>* subscriptionIdentifiersSample3;
@property ( strong, readonly ) NSArray <NSString*>* subscriptionIdentifiersSample4;

#pragma mark - Testing

+ ( BOOL ) isTestMethodPositive: ( SEL )_TestMethodSel;
+ ( BOOL ) isTestMethodNegative: ( SEL )_TestMethodSel;

@end // TauTestCase class