//
//  LHSDiigo.h
//  LHSDiigo
//
//  Created by Dan Loewenherz on 3/25/14.
//  Copyright (c) 2014 Lionheart Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString * const LHSDiigoBaseURL = @"https://secure.diigo.com/api/v2/";

typedef void (^LHSDiigoEmptyBlock)();
typedef void (^LHSDiigoGenericBlock)(id);
typedef void (^LHSDiigoArrayBlock)(NSArray *);
typedef void (^LHSDiigoErrorBlock)(NSError *);

@interface LHSDiigoClient : NSObject <NSURLConnectionDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSData *receivedData;

+ (instancetype)sharedClient;

- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
            success:(LHSDiigoGenericBlock)success
            failure:(LHSDiigoErrorBlock)failure;

- (void)setUsername:(NSString *)username
           password:(NSString *)password;

@end
