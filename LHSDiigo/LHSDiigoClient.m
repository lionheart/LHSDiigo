//
//  LHSDiigo.m
//  LHSDiigo
//
//  Created by Dan Loewenherz on 3/25/14.
//  Copyright (c) 2014 Lionheart Software LLC. All rights reserved.
//

#import "LHSDiigoClient.h"
#import "NSString+URLEncoding.h"

@interface NSDictionary (LHSDiigoAdditions)

- (NSString *)_queryParametersToString;

@end

@implementation NSDictionary (LHSDiigoAdditions)

- (NSString *)_queryParametersToString {
    NSMutableArray *items = [NSMutableArray array];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
        [items addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }];
    
    if (items.count > 0) {
        return [items componentsJoinedByString:@"&"];
    }
    else {
        return nil;
    }
}

@end

@interface LHSDiigoClient ()

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

@implementation LHSDiigoClient

+ (instancetype)sharedClient {
    static LHSDiigoClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[LHSDiigoClient alloc] init];
        
        _sharedClient.session = [NSURLSession sessionWithConfiguration:nil
                                                              delegate:_sharedClient
                                                         delegateQueue:[NSOperationQueue currentQueue]];
    });
    return _sharedClient;
}

+ (instancetype)sharedClientWithKey:(NSString *)key {
    static LHSDiigoClient *_sharedClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[LHSDiigoClient alloc] init];
        
        _sharedClient.session = [NSURLSession sessionWithConfiguration:nil
                                                              delegate:_sharedClient
                                                         delegateQueue:[NSOperationQueue currentQueue]];
        _sharedClient.key = key;
    });
    return _sharedClient;
}

- (void)requestPath:(NSString *)path
             method:(NSString *)method
         parameters:(NSDictionary *)parameters
         completion:(LHSDiigoGenericBlock)completion {
    if (!self.key) {
        NSError *error;
        completion(nil, error);
    }
    NSMutableArray *urlComponents = [NSMutableArray arrayWithObject:LHSDiigoBaseURL];
    [urlComponents addObject:path];
    
    NSString *body = [parameters _queryParametersToString];
    if (![method isEqualToString:@"POST"] && body) {
        [urlComponents addObject:@"?"];
        [urlComponents addObject:body];
    }
 
    NSLog(@"%@", urlComponents);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[urlComponents componentsJoinedByString:@""]]];
    request.HTTPMethod = method;
    
    if ([method isEqualToString:@"POST"]) {
        request.HTTPBody = [body dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     if (error) {
                                                         completion(nil, error);
                                                     }
                                                     else {
                                                         self.receivedData = data;
                                                         completion(data, nil);
                                                     }

                                                 }];
    [task resume];
}

#pragma mark - Authentication

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
                            didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
                              completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition,NSURLCredential *credential))completionHandler {
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:self.username
                                                             password:self.password
                                                          persistence:NSURLCredentialPersistenceForSession];
    completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
}

- (void)setUsername:(NSString *)username password:(NSString *)password {
    self.username = username;
    self.password = password;
}


#pragma mark - Bookmarks

- (void)bookmarksWithTag:(NSString *)tags
                  start:(NSInteger)start
                   count:(NSInteger)count
                    sort:(NSInteger)sort
                  filter:(NSString *)filter
                    list:(NSString *)list
                 completion:(LHSDiigoGenericBlock)completion {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"key"] = self.key;
    parameters[@"user"] = self.username;
    
    if (tags) {
       parameters[@"tags"] = tags;
    }
    
    if (start != -1) {
     parameters[@"start"] = [@(start) stringValue];
    }
    
    if (count != -1 ) {
        parameters[@"count"] = [@(count) stringValue];
    }
    
    if (sort) {
        parameters[@"sort"] = [@(sort) stringValue];
    }
    
    if (filter) {
       parameters[@"filter"] = filter;
    }
    
    if (list) {
        parameters[@"list"] = list;
    }
    
    [self requestPath:@"bookmarks" method:@"GET" parameters:parameters completion:completion];
    
}

- (void)addBookmarkWithURL:(NSString *)url
                     title:(NSString *)title
               description:(NSString *)description
                      tags:(NSArray *)tags
                    shared:(NSString *)shared
                 readLater:(NSString *)readLater
                   completion:(LHSDiigoGenericBlock)completion {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"key"] = self.key;
    parameters[@"url"] = url;
    parameters[@"title"] = title;
    
    if (description) {
       parameters[@"description"] = description;
    }
    
    if (tags) {
        NSString *encodedTags = [tags componentsJoinedByString:@","];
        parameters[@"tags"] = encodedTags;
    }
    
    if (shared) {
        parameters[@"shared"] = shared;
    }
    
    if (readLater) {
        parameters[@"readLater"] = readLater;
    }
    
    [self requestPath:@"bookmarks" method:@"POST" parameters:parameters completion:completion];
}

@end
