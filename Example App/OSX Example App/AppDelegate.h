//
//  AppDelegate.h
//  OSX Example App
//
//  Created by Khwaab Dave on 11/25/14.
//  Copyright (c) 2014 Nod Inc. All rights reserved.
//
//
//
//  OpenSpatial OSX Example App
//
//  This app shows how to use the OpenSpatial SDK in OSX
//  Here are the basic steps the app goes through
//  1. Setup the SDK classes and scan for devices
//  2. Implement all scanning callbacks and send names to table views
//      To select a device
//  3. Connect to the device
//  4. Callback from connect
//  5. Subscribe to Events
//  6. Callback from Events
//

#import <Cocoa/Cocoa.h>
#import "OpenSpatialBluetooth.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,
OpenSpatialBluetoothDelegate,
NSTableViewDataSource,
NSTableViewDelegate>

//OpenSpatialBluetooth: the class consumed in the SDK
@property OpenSpatialBluetooth* opSpcBt;

//misc ui properties
@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property (weak) IBOutlet NSTextField *numRingsLab;
@property (weak) IBOutlet NSTableView *tableView;
@property (weak) IBOutlet NSTableView *pairedTableView;
@property CBPeripheral* connectedDevice;
@end

