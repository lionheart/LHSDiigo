//
//  LHSDiigoTests.m
//  LHSDiigoTests
//
//  Created by Dan Loewenherz on 3/25/14.
//  Copyright (c) 2014 Lionheart Software LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LHSDiigoClient.h"
#import "XCTestCase+AsyncTesting.h"


@interface LHSDiigoTests : XCTestCase

@end

@implementation LHSDiigoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    //XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
    LHSDiigoClient *diigoClient = [LHSDiigoClient sharedClient];
    NSDictionary *apiParameters = @{ @"key" : @"37d50bc8a88b01b5", @"user" : @"jerrypainter"};
    [diigoClient setUsername:@"jerrypainter" password:@"wzx13605701028"];
    
    LHSDiigoGenericBlock successBlock = ^(NSData *data) {
        NSError *error;
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSString *url = [jsonObject[0] objectForKey:@"url"];
        NSLog(@"%@",url);
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    };
    
    [diigoClient requestPath:@"bookmarks" method:@"GET" parameters:apiParameters success:successBlock failure:nil];
    [self waitForStatus: XCTAsyncTestCaseStatusSucceeded timeout:60];
    
   
}

@end
