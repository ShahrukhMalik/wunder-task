//
//  WDCoordinate.m
//  Wunder
//
//  Created by Shahrukh on 07/12/2016.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WDCoordinate.h"


#pragma mark -

@implementation WDCoordinate

+ (WDCoordinate *)coordinateFromArray:(NSArray *)array {
    WDCoordinate *coordinate = [[WDCoordinate alloc] init];
    coordinate.longitude = [[array objectAtIndex:0] floatValue];
    coordinate.latitude = [[array objectAtIndex:1] floatValue];
    
    return coordinate;
}

@end
