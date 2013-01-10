//
//  CMPeripheralScanner.m
//  NearbyDevicesScanner
//
//  Created by Mathias Hansen on 12/6/12.
//  Copyright (c) 2012 Mathias Hansen. All rights reserved.
//

#import "CMPeripheralScanner.h"

@implementation CMPeripheralScanner

- (id)initWithDelegate:(id<CMPeripheralScannerDelegate>)delegate
{
    self = [super init];
    if (self) {
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        self.delegate = delegate;
    }
    
    return self;
}

+ (BOOL)isSupported
{
    // Only for iOS 6.0
    if (NSClassFromString(@"CBPeripheralManager") == nil) {
        return NO;
    }
    
    // TODO: Make a check to see if the CBPeripheralManager is in unsupported state.
    return YES;
}

- (void)startScanning
{
    [self stopScanning];
    
    NSArray *services = [NSArray arrayWithObject:nil];
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [centralManager scanForPeripheralsWithServices:services options:options];
}

- (void)stopScanning
{
    [centralManager stopScan];
}

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state)
    {
        case CBCentralManagerStateUnknown:
        {
            NSLog(@"State unknown, update imminent.");
            break;
        }
        case CBCentralManagerStateResetting:
        {
            NSLog(@"The connection with the system service was momentarily lost, update imminent.");
            break;
        }
        case CBCentralManagerStateUnsupported:
        {
            NSLog(@"The platform doesn't support Bluetooth Low Energy");
            break;
        }
        case CBCentralManagerStateUnauthorized:
        {
            NSLog(@"The app is not authorized to use Bluetooth Low Energy");
            break;
        }
        case CBCentralManagerStatePoweredOff:
        {
            NSLog(@"Bluetooth is currently powered off.");
            break;
        }
        case CBCentralManagerStatePoweredOn:
        {
            NSLog(@"Bluetooth is currently powered on and available to use.");
            [centralManager scanForPeripheralsWithServices:nil options:nil];
            break;
        }
        default:
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals{
    NSLog(@"didRetrievePeripherals");
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Found peripheral w/ UUID: %@ RSSI: %@ \n AdvData: %@",peripheral.UUID,RSSI,advertisementData);
    NSLog(@"Services found: %d",peripheral.services.count);
    for (CBService * service in peripheral.services)
    {
        NSLog(@"Found service: %@ w/ UUID %@", service, service.UUID);
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDiscoverDeviceWithName:)])
    {
        [self.delegate didDiscoverDeviceWithName:[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
    }
}

@end
