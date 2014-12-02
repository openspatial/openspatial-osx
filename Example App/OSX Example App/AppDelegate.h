//
//  AppDelegate.h
//  OSX Example App
//
//  Created by Khwaab Dave on 11/25/14.
//  Copyright (c) 2014 Nod Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OpenSpatialBluetooth.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, OpenSpatialBluetoothDelegate>

@property (unsafe_unretained) IBOutlet NSTextView *textView;
@property OpenSpatialBluetooth* opSpcBt;
@property (weak) IBOutlet NSTextField *numRingsLab;

@end

