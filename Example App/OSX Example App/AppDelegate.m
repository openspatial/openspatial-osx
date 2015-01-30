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
    //MISC UI SETUP
    [self.tableView setDelegate: self];
    [self.tableView setDataSource:self];
    [self.pairedTableView setDelegate:self];
    [self.pairedTableView setDataSource:self];
    [self.textView setEditable:false];
    
    //OpenSpatial Setup amd scan
    self.opSpcBt = [OpenSpatialBluetooth sharedBluetoothServ];
    [self.opSpcBt setDelegate:self];
    [self.opSpcBt scanForPeripherals];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

//subscribe to appropriate events (in this case all) called after a
//connection is made
- (IBAction)subscribe:(id)sender
{
        [self.opSpcBt subscribeToGestureEvents:self.connectedDevice.name];
        [self.opSpcBt subscribeToButtonEvents:self.connectedDevice.name];
        [self.opSpcBt subscribeToRotationEvents:self.connectedDevice.name];
        [self.opSpcBt subscribeToPointerEvents:self.connectedDevice.name];
}
- (IBAction)unsubscribe:(id)sender
{
    [self.opSpcBt unsubscribeFromRotationEvents:self.connectedDevice.name];
    [self.opSpcBt unsubscribeFromPointerEvents:self.connectedDevice.name];
    [self.opSpcBt unsubscribeFromGestureEvents:self.connectedDevice.name];
    [self.opSpcBt unsubscribeFromButtonEvents:self.connectedDevice.name];
}

//Connect to a device
- (IBAction)connect:(id)sender
{
    if(self.tableView.selectedRow >= 0)
    {
        CBPeripheral* perph = [self.opSpcBt.foundPeripherals objectAtIndex:self.tableView.selectedRow];
        self.connectedDevice = perph;
        [self.opSpcBt connectToPeripheral:self.connectedDevice];
    }
    else if(self.pairedTableView.selectedRow >= 0)
    {
        CBPeripheral* perph = [self.opSpcBt.pairedPeripherals objectAtIndex:self.pairedTableView.selectedRow];
        self.connectedDevice = perph;
        [self.opSpcBt connectToPeripheral:self.connectedDevice];
    }
}

//Callback when SDK finda a unpaired device
- (void) didFindNewScannedDevice:(NSArray *)peripherals
{
    [self.tableView reloadData];
}

//Callback when SDK finds a paired device
- (void) didFindNewPairedDevice: (NSArray*) peripherals
{
    [self.pairedTableView reloadData];
}

//Callback when SDK successfully connects to a Nod
-(void) didConnectToNod:(CBPeripheral *)peripheral
{
    [self.numRingsLab setStringValue:peripheral.name];
}

/*
 *                      EVENT CALLBACKS
 */
- (ButtonEvent*) buttonEventFired:(ButtonEvent *)buttonEvent
{
    NSString* string = [NSString stringWithFormat:@"\nButton Event: %d",buttonEvent.eventNum];
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
                        gestureEvent.eventNum];
    [self appendToMyTextView:string];
    return gestureEvent;
}

//MISC TABLE VIEW FCNs
- (void)appendToMyTextView:(NSString*)text
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAttributedString* attr = [[NSAttributedString alloc] initWithString:text];

        [[self.textView textStorage] appendAttributedString:attr];
        [self.textView scrollRangeToVisible:NSMakeRange([[self.textView string] length], 0)];
    });
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    if(aTableView == self.pairedTableView)
    {
        return self.opSpcBt.pairedPeripherals.count;
    }
    if(aTableView == self.tableView)
    {
        return self.opSpcBt.foundPeripherals.count;
    }
    return 0;
}

- (id)tableView:(NSTableView *)aTableView
objectValueForTableColumn:(NSTableColumn *)aTableColumn
            row:(NSInteger)rowIndex
{
    NSString* str;
    if(aTableView == self.pairedTableView)
    {
        CBPeripheral* perph = [self.opSpcBt.pairedPeripherals objectAtIndex:rowIndex];
        str = perph.name;
    }
    if(aTableView == self.tableView)
    {
        CBPeripheral* perph = [self.opSpcBt.foundPeripherals objectAtIndex:rowIndex];
        str = perph.name;
    }
    return str;
}


@end
