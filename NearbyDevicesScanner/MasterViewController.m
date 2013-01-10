//
//  MasterViewController.m
//  NearbyDevicesScanner
//
//  Created by Mathias Hansen on 12/6/12.
//  Copyright (c) 2012 Mathias Hansen. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Show activity indicator
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    UIBarButtonItem *activityIndicatorButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicatorView];
    self.navigationItem.leftBarButtonItem = activityIndicatorButton;
    [activityIndicatorView startAnimating];
    
    _objects = [[NSMutableArray alloc] init];
    
    // Initialize and start advertiser and scanner
    advertiser = [[CMPeripheralAdvertiser alloc] init];
    scanner = [[CMPeripheralScanner alloc] initWithDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    cell.textLabel.text = [_objects objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - CBPeripheralScannerDelegate
- (void)didDiscoverDeviceWithName:(NSString*)deviceName
{
    if (deviceName != nil) {
        [_objects addObject:deviceName];
        [self.tableView reloadData];
    }
}

@end
