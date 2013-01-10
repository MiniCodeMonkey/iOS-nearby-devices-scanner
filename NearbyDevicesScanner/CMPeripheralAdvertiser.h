//
//  CMPeripheralAdvertiser.h
//  NearbyDevicesScanner
//
//  Created by Mathias Hansen on 12/6/12.
//  Copyright (c) 2012 Mathias Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CMPeripheralAdvertiser : NSObject<CBPeripheralManagerDelegate> {
    CBPeripheralManager *peripheralManager;
    CBMutableCharacteristic *transferCharacteristic;
    CBMutableService *transferService;
}

- (id)init;
+ (BOOL)isSupported;
- (void)startAdvertising;
- (void)stopAdvertising;
- (BOOL)isAdvertising;

@end
