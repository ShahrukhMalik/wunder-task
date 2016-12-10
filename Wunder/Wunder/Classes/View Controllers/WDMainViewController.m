//
//  WDMainViewController.m
//  Wunder
//
//  Created by Shahrukh on 07/12/2016.
//  Copyright © 2016 Home. All rights reserved.
//

#import <MapKit/MapKit.h>

#import "WDMainViewController.h"

#import "WDAPIClient.h"
#import "WDSession.h"
#import "WDPlacemark.h"

#import "WDCarInfoTableViewCell.h"

#import "MBProgressHUD.h"

static NSString *kWDCarInfoCellIdentifier = @"WDCarInfoCellIdentifier";


#pragma mark -

@interface WDMainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *mapContainerView;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) UIRefreshControl *refreshControl;

@property (assign, nonatomic) BOOL mapInitiallyConfigured;

@end


#pragma mark -

@implementation WDMainViewController


#pragma mark -
#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Cars";
    
    self.navigationController.navigationBar.translucent = NO;
    
    self.mapInitiallyConfigured = NO;
    
    // Register custom nib for cell
    [self.tableView registerNib:[UINib nibWithNibName:@"WDCarInfoTableViewCell" bundle:nil] forCellReuseIdentifier:kWDCarInfoCellIdentifier];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 182.0f;
    
    [self sendPlacemarksRequest];
    
    // Adding pull to refresh
    self.refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // For full width separators of UITableView
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[WDSession sharedSession].carPlacemarks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WDCarInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWDCarInfoCellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Populating data in cell
    WDPlacemark *placemark = [[WDSession sharedSession].carPlacemarks objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = placemark.name;
    cell.vinLabel.text = placemark.vin;
    cell.exteriorLabel.text = placemark.exterior;
    cell.interiorLabel.text = placemark.interior;
    cell.fuelLabel.text = [NSString stringWithFormat:@"%ld", (long)placemark.fuel];
    cell.addressLabel.text = placemark.address;
    
    // Alternate background colors for cell to improve readability
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = [UIColor whiteColor];
        
    } else {
        cell.backgroundColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.0f];
    }
    
    return cell;
}


#pragma mark -
#pragma mark MKMapViewDelegate methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%s", __FUNCTION__);
    NSArray *annotations = [self.mapView annotations];
    
    for (MKPointAnnotation *ann in annotations) {
        
        if (view.annotation != ann) {
            
            // Show selected annotation, hide for all others
            [[self.mapView viewForAnnotation:ann] setHidden:YES];
            [[self.mapView viewForAnnotation:ann] setEnabled:NO];
        }
    }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%s", __FUNCTION__);
    NSArray *annotations = [self.mapView annotations];
    
    for (MKPointAnnotation *ann in annotations) {
        
        // Show all annotations
        [[self.mapView viewForAnnotation:ann] setHidden:NO];
        [[self.mapView viewForAnnotation:ann] setEnabled:YES];
    }
}


#pragma mark -
#pragma mark Action methods

- (IBAction)segmentedControlValueChanged:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        // List
        self.mapContainerView.hidden = YES;
        self.tableView.hidden = NO;
        
    } else if (sender.selectedSegmentIndex == 1) {
        // Map
        self.tableView.hidden = YES;
        self.mapContainerView.hidden = NO;
        
        if (!self.mapInitiallyConfigured) {
            
            // Configuring map view (Focusing on Hamburg)
            CLLocation *initialLocation = [[CLLocation alloc] initWithLatitude:53.551086 longitude:9.993682];
            [self centerMapOnLocation:initialLocation];
            [self updatePlacemarksOnMap];
            self.mapInitiallyConfigured = YES;
        }
    }
}

- (void)refreshData {
    [self sendPlacemarksRequest];
}


#pragma mark -
#pragma mark Private methods

- (void)sendPlacemarksRequest {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = @"Please Wait...";
    
    // DEVELOPER'S NOTE: Weak self is used in block to avoid retain cycle
    __weak typeof(self) weakSelf = self;
    
    [[WDAPIClient sharedClient] sendFeedOfCarsRequestWithCompletionBlock:^(NSError *error, NSDictionary *responseDict) {
        [weakSelf.refreshControl endRefreshing];
        [MBProgressHUD hideHUDForView:weakSelf.view animated:true];
        
        if (error == nil) {
            NSArray *infoArr = [responseDict objectForKey:@"placemarks"];
            NSMutableArray *placemarks = [WDPlacemark arrayOfPlacemarksFromInfoArray:infoArr];
            
            // Populating array of WDPlacemark objects
            [WDSession sharedSession].carPlacemarks = placemarks;
            
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
            
        } else {
            
            // Error handling
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [weakSelf presentViewController:alertController animated:YES completion:nil];
        }
    }];
}

- (void)centerMapOnLocation:(CLLocation *)loc {
    CLLocationDistance regionRadius = 1000; // 1000 meters
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc.coordinate, regionRadius * 2, regionRadius * 2);
    [self.mapView setRegion:region animated:YES];
}

- (void)updatePlacemarksOnMap {
    NSMutableArray *placemarks = [[NSMutableArray alloc] init];
    
    for (WDPlacemark *p in [WDSession sharedSession].carPlacemarks) {
        MKPointAnnotation *ann = [[MKPointAnnotation alloc] init];
        ann.coordinate = CLLocationCoordinate2DMake(p.coordinate.latitude, p.coordinate.longitude);
        ann.title = p.name;
        [placemarks addObject:ann];
    }
    
    [self.mapView addAnnotations:placemarks];
}

@end
