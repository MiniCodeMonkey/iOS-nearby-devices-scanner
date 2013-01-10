//
//  CMPeripheralAdvertiser.m
//  NearbyDevicesScanner
//
//  Created by Mathias Hansen on 12/6/12.
//  Copyright (c) 2012 Mathias Hansen. All rights reserved.
//

#import "CMPeripheralAdvertiser.h"
#import "UIDevice+IdentifierAddition.h"

#define kTransferCharacteristicUUID @"31661540-3FF4-11E2-A25F-0800200C9A66"
#define kTransferServiceUUID @"31661541-3FF4-11E2-A25F-0800200C9A66"
#define kServiceName @"SENSIBLE"

@implementation CMPeripheralAdvertiser

- (id)init
{
    self = [super init];
    if (self) {
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
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

- (void)startAdvertising
{
    if ([self isAdvertising])
        [self stopAdvertising];
    
    CBUUID *serviceUUID = [CBUUID UUIDWithString:kTransferServiceUUID];
    NSDictionary *advertisment = @{
        CBAdvertisementDataServiceUUIDsKey : @[serviceUUID],
        CBAdvertisementDataLocalNameKey: [NSString stringWithFormat:@"%@-%@", kServiceName, [[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]]
    };
    [peripheralManager startAdvertising:advertisment];
}

- (void)stopAdvertising
{
    [peripheralManager stopAdvertising];
}

- (BOOL)isAdvertising
{
    return [peripheralManager isAdvertising];
}

#pragma mark - CBPeripheralManagerDelegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral;
{
    switch (peripheral.state)
    {
        case CBPeripheralManagerStateUnknown:
        {
            NSLog(@"[Peripheral State Change] State unknown, update imminent.");
            break;
        }
        case CBPeripheralManagerStateResetting:
        {
            NSLog(@"[Peripheral State Change] The connection with the system service was momentarily lost, update imminent.");
            break;
        }
        case CBPeripheralManagerStateUnsupported:
        {
            NSLog(@"[Peripheral State Change] The platform doesn't support Bluetooth Low Energy");
            break;
        }
        case CBPeripheralManagerStateUnauthorized:
        {
            NSLog(@"[Peripheral State Change] The app is not authorized to use Bluetooth Low Energy");
            break;
        }
        case CBPeripheralManagerStatePoweredOff:
        {
            NSLog(@"[Peripheral State Change] Bluetooth is currently powered off.");
            
            [peripheralManager removeService:transferService];
            transferService = nil;
            [self stopAdvertising];
            
            break;
        }
        case CBPeripheralManagerStatePoweredOn:
        {
            NSLog(@"[Peripheral State Change] Bluetooth is currently powered on and available to use.");
            
            // Define characteristics
            transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:kTransferCharacteristicUUID]
                                                                        properties:CBCharacteristicPropertyNotify
                                                                             value:nil
                                                                       permissions:CBAttributePermissionsReadable];
            
            // Then the service
            transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:kTransferServiceUUID]
                                                                               primary:YES];
            
            // Add the characteristic to the service
            transferService.characteristics = @[transferCharacteristic];
            
            // And add it to the peripheral manager
            [peripheralManager addService:transferService];
            
            break;
        }
        default:
            break;
    }
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral
            didAddService:(CBService *)service
                    error:(NSError *)error {
    // As soon as the service is added, we should start advertising.
    [self startAdvertising];
}

@end
