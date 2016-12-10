//
//  WDAPIClient.m
//  Wunder
//
//  Created by Shahrukh on 07/12/2016.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WDAPIClient.h"

#import "AFHTTPSessionManager.h"


#pragma mark -

@interface WDAPIClient()

@property (strong, nonatomic) AFHTTPSessionManager *manager;

@end


#pragma mark -

@implementation WDAPIClient

+ (instancetype)sharedClient {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self.manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    self.manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [self.manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    return [super init];
}

- (void)sendFeedOfCarsRequestWithCompletionBlock:(WDAPIClientCompletionBlock)block {
    NSString *urlString = @"https://s3-us-west-2.amazonaws.com/wunderbucket/locations.json";
    
    [self.manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject
                                                             options:kNilOptions
                                                               error:&error];
        
        NSLog(@"JSON: %@", json);
        block(nil, json);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
        block(error, nil);
    }];
}

@end
