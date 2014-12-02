//
//  AppDelegate.m
//  OSX Example App
//
//  Created by Khwaab Dave on 11/25/14.
//  Copyright (c) 2014 Nod Inc. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.opSpcBt = [OpenSpatialBluetooth sharedBluetoothServ];
    [self.opSpcBt setDelegate:self];
    [self.textView setEditable:false];
    [self.opSpcBt scanForPeripherals];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)subscribe:(id)sender
{
    for(CBPeripheral* per in [self.opSpcBt.connectedPeripherals allKeys])
    {
        [self.opSpcBt subscribeToGestureEvents:per.name];
        [self.opSpcBt subscribeToButtonEvents:per.name];
        [self.opSpcBt subscribeToRotationEvents:per.name];
        [self.opSpcBt subscribeToPointerEvents:per.name];
    }
}

- (void) didFindNewDevice:(NSArray *)peripherals
{
    for(CBPeripheral* per in peripherals)
    {
        [self.opSpcBt connectToPeripheral:per];
    }
}

-(void) didConnectToNod:(CBPeripheral *)peripheral
{
    [self.numRingsLab setStringValue:peripheral.name];
}

- (ButtonEvent*) buttonEventFired:(ButtonEvent *)buttonEvent
{
    NSString* string = [NSString stringWithFormat:@"\nButton Event: %d",buttonEvent.myButtonEventNum];
    [self appendToMyTextView:string];
    return buttonEvent;
}

- (RotationEvent*) rotationEventFired:(RotationEvent *)rotationEvent
{
    NSString* string = [NSString stringWithFormat:@"\nRoation Event: %f,%f,%f",rotationEvent.yaw,
                        rotationEvent.pitch,rotationEvent.roll];
    [self appendToMyTextView:string];
    return rotationEvent;
}

- (PointerEvent*) pointerEventFired:(PointerEvent *)pointerEvent
{
    NSString* string = [NSString stringWithFormat:@"\nPointer Event: %d,%d",pointerEvent.xVal,
                        pointerEvent.yVal];
    [self appendToMyTextView:string];
    return pointerEvent;
}

- (GestureEvent*) gestureEventFired:(GestureEvent *)gestureEvent
{
    NSString* string = [NSString stringWithFormat:@"\nGesture Event: %d",
                        gestureEvent.myGestureEventNum];
    [self appendToMyTextView:string];
    return gestureEvent;
}


- (void)appendToMyTextView:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString* attr = [[NSAttributedString alloc] initWithString:text];

        [[self.textView textStorage] appendAttributedString:attr];
        [self.textView scrollRangeToVisible:NSMakeRange([[self.textView string] length], 0)];
    });
}
@end
