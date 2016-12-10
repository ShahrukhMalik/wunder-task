//
//  WDPlacemark.h
//  Wunder
//
//  Created by Shahrukh on 07/12/2016.
//  Copyright © 2016 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WDCoordinate.h"


#pragma mark -

@interface WDPlacemark : NSObject

@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *engineType;
@property (strong, nonatomic) NSString *exterior;
@property (strong, nonatomic) NSString *interior;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *vin;

@property (assign, nonatomic) NSInteger fuel;

@property (strong, nonatomic) WDCoordinate *coordinate;

+ (WDPlacemark *)placemarkFromInfo:(NSDictionary *)info;

+ (NSMutableArray *)arrayOfPlacemarksFromInfoArray:(NSArray *)infoArray;

@end
