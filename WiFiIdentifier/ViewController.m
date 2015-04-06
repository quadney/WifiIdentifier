//
//  ViewController.m
//  WiFiIdentifier
//
//  Created by Sydney Richardson on 4/5/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "ViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include "WifiDataStore.h"
#import "WifiData.h"

@interface ViewController () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *libraryPicker;
@property (weak, nonatomic) IBOutlet UILabel *bssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *ssidLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipAddressLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateInfo:self];
    [self enableBackgroundTapToDismissKeyboard];
    
}
- (IBAction)updateInfo:(id)sender {
    // refering to Stack Overflow article,
    // http://stackoverflow.com/questions/16470615/is-it-possible-to-get-the-ssid-mac-address-of-currently-connected-wifi-network
    // because I don't know much about networking... this was a very informative and educational answer with many links to get the job done.
    
    // First need to get the SSID number
    // Then get the Gateway address
    // use those to convert into a MAC address using ARP (Address Resolution Protocol)
    NSDictionary *ssid = [self fetchSSIDInfo];
    NSString *ipAddress = [self getIPAddress];
    
    self.bssidLabel.text = [NSString stringWithFormat:@"%@", [ssid objectForKey:@"BSSID"]];
    self.ssidLabel.text = [NSString stringWithFormat:@"%@", [ssid objectForKey:@"SSID"]];
    self.ipAddressLabel.text = [NSString stringWithFormat:@"%@", ipAddress];
}

- (IBAction)addCurrentInfoToList:(id)sender {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:[NSString stringWithFormat:@"%lu", [self.libraryPicker selectedRowInComponent:1]+1] forKey:@"floor"];
    [dic setValue:self.bssidLabel.text forKey:@"BSSID"];
    [dic setValue:self.ssidLabel.text forKey:@"SSID"];
    [dic setValue:self.ipAddressLabel.text forKey:@"IP"];
    
    [[WifiDataStore sharedStore] addWifiInfoToLibraryIndex:[self.libraryPicker selectedRowInComponent:0] withDictionary:dic];
}

#pragma mark - UIPickerViewDelegate/DataSource Methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if(component == 0)
        return [[WifiDataStore sharedStore] numberOfLibraries];
    else
        return 6;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [[[WifiDataStore sharedStore] getWifiDataAtIndex:(int)row] libraryName];
    }
    
    return [NSString stringWithFormat:@"%lu", row+1];
}

#pragma mark - WIFI Identification stuff

// getting the SSID number
// http://stackoverflow.com/questions/5198716/iphone-get-ssid-without-private-library
/** Returns first non-empty SSID network info dictionary.
 *  @see CNCopyCurrentNetworkInfo */
- (NSDictionary *)fetchSSIDInfo
{
    NSArray *interfaceNames = CFBridgingRelease(CNCopySupportedInterfaces());
    //NSLog(@"%s: Supported interfaces: %@", __func__, interfaceNames);
    
    NSDictionary *SSIDInfo;
    for (NSString *interfaceName in interfaceNames) {
        SSIDInfo = CFBridgingRelease(
                                     CNCopyCurrentNetworkInfo((__bridge CFStringRef)interfaceName));
        //NSLog(@"%s: %@ => %@", __func__, interfaceName, SSIDInfo);
        
        BOOL isNotEmpty = (SSIDInfo.count > 0);
        if (isNotEmpty) {
            break;
        }
    }
    return SSIDInfo;
}

// http://stackoverflow.com/questions/4872196/how-to-get-the-wifi-gateway-address-on-the-iphone
// http://zachwaugh.me/posts/programmatically-retrieving-ip-address-of-iphone/
- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

#pragma mark - Dismiss Keyboard Methods

- (void)enableBackgroundTapToDismissKeyboard {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(backgroundWasTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)backgroundWasTapped:(UITapGestureRecognizer *)tapGesture {
    [self.view endEditing:YES];
}

#pragma mark - TextField methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
