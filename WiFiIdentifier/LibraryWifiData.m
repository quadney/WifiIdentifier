//
//  LIbraryWifiData.m
//  WiFiIdentifier
//
//  Created by Sydney Richardson on 4/6/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "LibraryWifiData.h"

@implementation LibraryWifiData

- (id)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.libraryName = name;
        self.wifiBSSIDCodes = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Name: %@, BSSID Codes: %@, %@",self.libraryName, self.wifiBSSIDCodes, [super description]];
}

@end
