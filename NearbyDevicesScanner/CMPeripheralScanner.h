//
//  CMPeripheralScanner.h
//  NearbyDevicesScanner
//
//  Created by Mathias Hansen on 12/6/12.
//  Copyright (c) 2012 Mathias Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@protocol CMPeripheralScannerDelegate <NSObject>

- (void)didDiscoverDeviceWithName:(NSString*)deviceName;

@end

@interface CMPeripheralScanner : NSObject<CBCentralManagerDelegate> {
    CBCentralManager *centralManager;
}

@property(nonatomic, assign) id<CMPeripheralScannerDelegate> delegate;

- (id)initWithDelegate:(id<CMPeripheralScannerDelegate>)delegate;
+ (BOOL)isSupported;
- (void)startScanning;
- (void)stopScanning;

@end
