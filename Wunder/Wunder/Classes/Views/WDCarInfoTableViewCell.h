//
//  WDCarInfoTableViewCell.h
//  Wunder
//
//  Created by Shahrukh on 07/12/2016.
//  Copyright © 2016 Home. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -

@interface WDCarInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *vinLabel;
@property (weak, nonatomic) IBOutlet UILabel *exteriorLabel;
@property (weak, nonatomic) IBOutlet UILabel *interiorLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuelLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;


@end
