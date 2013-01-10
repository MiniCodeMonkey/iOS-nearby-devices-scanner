//
//  MasterViewController.h
//  NearbyDevicesScanner
//
//  Created by Mathias Hansen on 12/6/12.
//  Copyright (c) 2012 Mathias Hansen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMPeripheralAdvertiser.h"
#import "CMPeripheralScanner.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController<CMPeripheralScannerDelegate> {
    CMPeripheralAdvertiser *advertiser;
    CMPeripheralScanner *scanner;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
