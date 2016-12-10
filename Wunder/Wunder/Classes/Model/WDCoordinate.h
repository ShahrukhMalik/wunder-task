//
//  WDCoordinate.h
//  Wunder
//
//  Created by Shahrukh on 07/12/2016.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark -

@interface WDCoordinate : NSObject

@property (assign, nonatomic) float latitude;
@property (assign, nonatomic) float longitude;

+ (WDCoordinate *)coordinateFromArray:(NSArray *)array;

@end
