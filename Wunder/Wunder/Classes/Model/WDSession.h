//
//  WDSession.h
//  Wunder
//
//  Created by Shahrukh on 07/12/2016.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -

@interface WDSession : NSObject

+ (instancetype)sharedSession;

@property (strong, nonatomic) NSMutableArray *carPlacemarks;

@end
