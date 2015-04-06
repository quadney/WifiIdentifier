//
//  WifiDataStore.h
//  WiFiIdentifier
//
//  Created by Sydney Richardson on 4/6/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WifiData.h"

@interface WifiDataStore : NSObject

+ (id)sharedStore;

@property (strong, nonatomic) NSMutableArray *libraryWifiObjects;

- (void)addWifiInfoToLibraryIndex:(NSUInteger)libraryIndex withDictionary:(NSDictionary *)dic;
- (int)numberOfLibraries;
- (WifiData *)getWifiDataAtIndex:(NSUInteger)index;
- (void)deleteWifiDataForLibraryAtIndex:(NSUInteger)libraryIndex andWifiIndex:(NSUInteger)wifiIndex;

@end
