//
//  WDPlacemark.m
//  Wunder
//
//  Created by Shahrukh on 07/12/2016.
//  Copyright © 2016 Home. All rights reserved.
//

#import "WDPlacemark.h"


#pragma mark -

@implementation WDPlacemark

+ (WDPlacemark *)placemarkFromInfo:(NSDictionary *)info {
    WDPlacemark *placemark = [[WDPlacemark alloc] init];
    placemark.address = [info objectForKey:@"address"];
    placemark.engineType = [info objectForKey:@"engineType"];
    placemark.exterior = [info objectForKey:@"exterior"];
    placemark.interior = [info objectForKey:@"interior"];
    placemark.name = [info objectForKey:@"name"];
    placemark.vin = [info objectForKey:@"vin"];
    
    NSNumber *n = [info objectForKey:@"fuel"];
    placemark.fuel = [n floatValue];
    
    placemark.coordinate = [WDCoordinate coordinateFromArray:[info objectForKey:@"coordinates"]];
    
    return placemark;
}

+ (NSMutableArray *)arrayOfPlacemarksFromInfoArray:(NSArray *)infoArray {
    NSMutableArray *placemarks = [[NSMutableArray alloc] init];
    
    for (NSDictionary *infoDict in infoArray) {
        WDPlacemark *pm = [WDPlacemark placemarkFromInfo:infoDict];
        [placemarks addObject:pm];
    }
    
    return placemarks;
}

@end
