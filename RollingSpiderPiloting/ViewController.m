/*
    Copyright (C) 2014 Parrot SA

    Redistribution and use in source and binary forms, with or without
    modification, are permitted provided that the following conditions
    are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the 
      distribution.
    * Neither the name of Parrot nor the names
      of its contributors may be used to endorse or promote products
      derived from this software without specific prior written
      permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
    "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
    LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
    FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
    COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
    INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
    BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS
    OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED 
    AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
    OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
    OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
    SUCH DAMAGE.
*/
//
//  ViewController.m
//  RollingSpiderPiloting
//
//  Created on 19/01/2015.
//  Copyright (c) 2015 Parrot. All rights reserved.
//

#import "DeviceController.h"
#import "ViewController.h"
#import <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>
#import "PilotingViewController.h"

#import <GameController/GameController.h>


@interface CellData ()
@end

@implementation CellData
@end

@interface ViewController () <DeviceControllerDelegate>
{
    GCController *_controller;
}

@property (nonatomic, strong) DeviceController* deviceController;
@property (nonatomic, strong) ARService *serviceSelected;

@end

@implementation ViewController 
{
    NSArray *tableData;
    //ARService *serviceSelected;
    
}

@synthesize tableView = _tableView;
@synthesize serviceSelected = _serviceSelected;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tableData = [NSArray array];
    _serviceSelected = nil;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controllerConnected:)
                                                 name:GCControllerDidConnectNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(controllerDisconnected:)
                                                 name:GCControllerDidDisconnectNotification
                                               object:nil];
    
    [GCController startWirelessControllerDiscoveryWithCompletionHandler:^{
        NSLog(@"Done discovering wireless controllers.");
    }];
}

- (void)controllerConnected:(NSNotification*)notification
{
    NSLog(@"CONECTADO AL MANDO");
    GCController *controller = notification.object;
    _controller = controller;
    
    __block ViewController *blockSelf = self;
    
    if (_controller.extendedGamepad) {
        _controller.extendedGamepad.valueChangedHandler =
        ^(GCExtendedGamepad *gamepad, GCControllerElement *element) {
            [blockSelf updateControlValues];
        };
    } else {
        _controller.gamepad.valueChangedHandler =
        ^(GCGamepad *gamepad, GCControllerElement *element) {
            [blockSelf updateControlValues];
        };
    }
}

- (void)controllerDisconnected:(NSNotification*)notification
{
    NSLog(@"Controller disconnected");
}

- (void)updateControlValues
{
    if (_controller.gamepad.buttonA.isPressed)
    {
        [self takeoffClick:nil];
    }
    
    if (_controller.gamepad.buttonY.isPressed)
        [self emergencyClick:nil];
    
    if (_controller.gamepad.buttonX.isPressed)
        [self landingClick:nil];
    
    if (_controller.extendedGamepad == nil) {
        return;
    }
    
    
    
//    if (_controller.extendedGamepad.leftThumbstick.up.isPressed)
//        [self pitchForwardTouchDown:nil];
//    else
//        [self pitchForwardTouchUp:nil];
//    
//    if (_controller.extendedGamepad.leftThumbstick.down.isPressed)
//        [self pitchBackTouchDown:nil];
//    else
//        [self pitchBackTouchUp:nil];
//    
//    if (_controller.extendedGamepad.leftThumbstick.left.isPressed)
//        [self rollLeftTouchDown:nil];
//    else
//        [self rollLeftTouchUp:nil];
//    
//    if (_controller.extendedGamepad.leftThumbstick.right.isPressed)
//        [self rollRightTouchDown:nil];
//    else
//        [self rollRightTouchUp:nil];
    
    if (_controller.extendedGamepad.leftThumbstick.up.isPressed)
            [self pitchForwardTouchDown:nil];
    
    else if (_controller.extendedGamepad.leftThumbstick.down.isPressed)
         [self pitchBackTouchDown:nil];
    
    else if (_controller.extendedGamepad.leftThumbstick.left.isPressed)
        [self rollLeftTouchDown:nil];
    
    else if (_controller.extendedGamepad.leftThumbstick.right.isPressed)
                [self rollRightTouchDown:nil];
            else
                [self rollRightTouchUp:nil];
    
    
    if (_controller.extendedGamepad.rightThumbstick.up.isPressed)
        [self gazUpTouchDown:nil];
    
    else if (_controller.extendedGamepad.rightThumbstick.down.isPressed)
         [self gazDownTouchDown:nil];
    
    else if (_controller.extendedGamepad.rightThumbstick.left.isPressed)
        [self yawLeftTouchDown:nil];
    
    else if (_controller.extendedGamepad.rightThumbstick.right.isPressed)
        [self yawRightTouchDown:nil];
    
    else
        [self yawRightTouchUp:nil];
    
//    if (_controller.extendedGamepad.rightThumbstick.up.isPressed)
//        [self gazUpTouchDown:nil];
//    else
//        [self gazUpTouchUp:nil];
//    
//    if (_controller.extendedGamepad.rightThumbstick.down.isPressed)
//        [self gazDownTouchDown:nil];
//    else
//        [self gazDownTouchUp:nil];
//    
//    if (_controller.extendedGamepad.rightThumbstick.left.isPressed)
//        [self yawLeftTouchDown:nil];
//    else
//        [self yawLeftTouchUp:nil];
//    
//    if (_controller.extendedGamepad.rightThumbstick.right.isPressed)
//        [self yawRightTouchDown:nil];
//    else
//        [self yawRightTouchUp:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self registerApplicationNotifications];
    [[ARDiscovery sharedInstance] start];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self unregisterApplicationNotifications];
    [[ARDiscovery sharedInstance] stop];
}

- (void)registerApplicationNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBackground:) name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name: UIApplicationWillEnterForegroundNotification object: nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(discoveryDidUpdateServices:) name:kARDiscoveryNotificationServicesDevicesListUpdated object:nil];
}

- (void)unregisterApplicationNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationWillEnterForegroundNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kARDiscoveryNotificationServicesDevicesListUpdated object:nil];
}

#pragma mark - application notifications
- (void)enteredBackground:(NSNotification*)notification
{
    NSLog(@"enteredBackground ... ");
}

- (void)enterForeground:(NSNotification*)notification
{
    NSLog(@"enterForeground ... ");
}

#pragma mark ARDiscovery notification
- (void)discoveryDidUpdateServices:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateServicesList:[[notification userInfo] objectForKey:kARDiscoveryServicesList]];
    });
}

- (void)updateServicesList:(NSArray *)services
{
    NSMutableArray *serviceArray = [NSMutableArray array];
    
    for (ARService *service in services)
    {
        if ([service.service isKindOfClass:[ARBLEService class]])
        {
            CellData *cellData = [[CellData alloc]init];
            
            [cellData setService:service];
            [cellData setName:service.name];
            [serviceArray addObject:cellData];
        }
    }
    
    tableData = serviceArray;
    [_tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [(CellData *)[tableData objectAtIndex:indexPath.row] name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _serviceSelected = [(CellData *)[tableData objectAtIndex:indexPath.row] service];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _deviceController = [[DeviceController alloc]initWithARService:_serviceSelected];
        [_deviceController setDelegate:self];
        BOOL connectError = [_deviceController start];
        
        NSLog(@"connectError = %d", connectError);
        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [_alertView dismissWithClickedButtonIndex:0 animated:TRUE];
        
//        });
        
        if (connectError)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    });

//    [self performSegueWithIdentifier:@"pilotingSegue" sender:self];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(([segue.identifier isEqualToString:@"pilotingSegue"]) && (_serviceSelected != nil))
    {
        PilotingViewController *pilotingViewController = (PilotingViewController *)[segue destinationViewController];
        
        [pilotingViewController setService: _serviceSelected];
    }
}

- (IBAction)emergencyClick:(id)sender
{
    [_deviceController sendEmergency];
}

- (IBAction)takeoffClick:(id)sender
{
    [_deviceController sendTakeoff];
}

- (IBAction)landingClick:(id)sender
{
    [_deviceController sendLanding];
}

//events for gaz:
- (IBAction)gazUpTouchDown:(id)sender
{
    [_deviceController setGaz:50];
}
- (IBAction)gazDownTouchDown:(id)sender
{
    [_deviceController setGaz:-50];
}

- (IBAction)gazUpTouchUp:(id)sender
{
    [_deviceController setGaz:0];
}
- (IBAction)gazDownTouchUp:(id)sender
{
    [_deviceController setGaz:0];
}

//events for yaw:
- (IBAction)yawLeftTouchDown:(id)sender
{
    [_deviceController setYaw:-50];
    
}
- (IBAction)yawRightTouchDown:(id)sender
{
    [_deviceController setYaw:50];
    
}

- (IBAction)yawLeftTouchUp:(id)sender
{
    [_deviceController setYaw:0];
}

- (IBAction)yawRightTouchUp:(id)sender
{
    [_deviceController setYaw:0];
}

//events for yaw:
- (IBAction)rollLeftTouchDown:(id)sender
{
    [_deviceController setFlag:1];
    [_deviceController setRoll:-50];
}
- (IBAction)rollRightTouchDown:(id)sender
{
    [_deviceController setFlag:1];
    [_deviceController setRoll:50];
}

- (IBAction)rollLeftTouchUp:(id)sender
{
    [_deviceController setFlag:0];
    [_deviceController setRoll:0];
}
- (IBAction)rollRightTouchUp:(id)sender
{
    [_deviceController setFlag:0];
    [_deviceController setRoll:0];
}

//events for pitch:
- (IBAction)pitchForwardTouchDown:(id)sender
{
    [_deviceController setFlag:1];
    [_deviceController setPitch:50];
}
- (IBAction)pitchBackTouchDown:(id)sender
{
    [_deviceController setFlag:1];
    [_deviceController setPitch:-50];
}

- (IBAction)pitchForwardTouchUp:(id)sender
{
    [_deviceController setFlag:0];
    [_deviceController setPitch:0];
}
- (IBAction)pitchBackTouchUp:(id)sender
{
    [_deviceController setFlag:0];
    [_deviceController setPitch:0];
}

- (void)onDisconnectNetwork:(DeviceController *)deviceController
{
    NSLog(@"onDisconnect ...");
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.navigationController popViewControllerAnimated:YES];
//    });
}

- (void)onUpdateBattery:(DeviceController *)deviceController batteryLevel:(uint8_t)percent;
{
    NSLog(@"onUpdateBattery");
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        NSString *text = [[NSString alloc] initWithFormat:@"%d%%", percent];
//        [_batteryLabel setText:text];
//    });
}

@end
