//
//  LibraryWifiDataViewController.m
//  WiFiIdentifier
//
//  Created by Sydney Richardson on 4/6/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LibraryWifiDataViewController.h"
#import "WifiDataStore.h"
#import "WifiData.h"

@interface LibraryWifiDataViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LibraryWifiDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[WifiDataStore sharedStore] numberOfLibraries];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[[WifiDataStore sharedStore] getWifiDataAtIndex:(int)section] libraryName];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[WifiDataStore sharedStore] getWifiDataAtIndex:section] wifiBSSIDCodes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WifiInfoCell"];
    
    NSDictionary *cellInfo = [[[[WifiDataStore sharedStore] getWifiDataAtIndex:indexPath.section] wifiBSSIDCodes] objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Floor: %@, SSID: %@\nBSSID: %@\nIP: %@", [cellInfo objectForKey:@"floor"], [cellInfo objectForKey:@"SSID"], [cellInfo objectForKey:@"BSSID"], [cellInfo objectForKey:@"IP"]];
    return cell;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [[WifiDataStore sharedStore] deleteWifiDataForLibraryAtIndex:indexPath.section andWifiIndex:indexPath.row];
        [self.tableView reloadData];
    }
}


@end
