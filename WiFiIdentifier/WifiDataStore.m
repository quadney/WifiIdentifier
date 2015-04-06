//
//  WifiDataStore.m
//  WiFiIdentifier
//
//  Created by Sydney Richardson on 4/6/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "WifiDataStore.h"
#import "WifiData.h"

#define kWifiDataKey        @"WifiData"
#define kWifiDataFile       @"wifidata.plist"

@implementation WifiDataStore

+ (id)sharedStore {
    static WifiDataStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

- (id)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use: [WifiDataStore sharedStore]"
                                 userInfo:nil];
    return nil;
}

- (id)initPrivate {
    self = [super init];
    if (self) {
        
        WifiData *marston = [[WifiData alloc] initWithName:@"Marston Library"];
        WifiData *west = [[WifiData alloc] initWithName:@"Library West"];
        WifiData *arch = [[WifiData alloc] initWithName:@"Architecture"];
        WifiData *law = [[WifiData alloc] initWithName:@"Law Library"];
        WifiData *edu = [[WifiData alloc] initWithName:@"Education Library"];
        
        self.libraryWifiObjects = [[NSMutableArray alloc] initWithObjects:marston, west, arch, law, edu, nil];
    }
    return self;
}

- (void)addWifiInfoToLibraryIndex:(NSUInteger)libraryIndex withDictionary:(NSDictionary *)dic {
    [[[self.libraryWifiObjects objectAtIndex:libraryIndex] wifiBSSIDCodes] addObject:dic];
}

- (int)numberOfLibraries {
    return (int)[self.libraryWifiObjects count];
}

- (WifiData *)getWifiDataAtIndex:(NSUInteger)index {
    return [self.libraryWifiObjects objectAtIndex:index];
}

- (void)deleteWifiDataForLibraryAtIndex:(NSUInteger)libraryIndex andWifiIndex:(NSUInteger)wifiIndex {
    [[[self.libraryWifiObjects objectAtIndex:libraryIndex] wifiBSSIDCodes] removeObjectAtIndex:wifiIndex];
}


@end
