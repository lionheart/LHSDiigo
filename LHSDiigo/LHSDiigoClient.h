//
//  LHSDiigo.h
//  LHSDiigo
//
//  Created by Dan Loewenherz on 3/25/14.
//  Copyright (c) 2014 Lionheart Software LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *LHSDiigoBaseURL = @"https://secure.diigo.com/api/v2/";


typedef void (^LHSDiigoEmptyBlock)();
typedef void (^LHSDiigoGenericBlock)(id, NSError *error );
typedef void (^LHSDiigoArrayBlock)(NSArray *);
typedef void (^LHSDiigoErrorBlock)(NSError *);


@interface LHSDiigoClient : NSObject <NSURLConnectionDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSData *receivedData;
@property (nonatomic, strong) NSString *ApiKey;

+ (instancetype)sharedClient;

- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
         completion:(LHSDiigoGenericBlock)completion;

- (void)setUsername:(NSString *)username
           password:(NSString *)password
             ApiKey:(NSString *)ApiKey;



- (void)bookmarksWithTag:(NSString *)tags
                  start:(NSInteger)start
                   count:(NSInteger)count
                    sort:(NSInteger)sort
                  filter:(NSString *)filter
                    list:(NSString *)list
                 completion:(LHSDiigoGenericBlock)completion;

- (void)addBookmarkWithURL:(NSString *)url
                     title:(NSString *)title
               description:(NSString *)description
                      tags:(NSArray *)tags
                    shared:(NSString *)shared
                 readLater:(NSString *)readLater
                completion:(LHSDiigoGenericBlock)completion;

@end
