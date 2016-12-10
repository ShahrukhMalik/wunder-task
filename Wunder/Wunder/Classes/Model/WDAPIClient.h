//
//  WDAPIClient.h
//  Wunder
//
//  Created by Shahrukh on 07/12/2016.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -

typedef void (^WDAPIClientCompletionBlock)(NSError *error, NSDictionary *responseDict);


#pragma mark -

@interface WDAPIClient : NSObject

+ (instancetype)sharedClient;

- (void)sendFeedOfCarsRequestWithCompletionBlock:(WDAPIClientCompletionBlock)block;

@end
