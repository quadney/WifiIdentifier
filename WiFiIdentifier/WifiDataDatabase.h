//
//  WifiDataDatabase.h
//  WiFiIdentifier
//
//  Created by Sydney Richardson on 4/6/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiDataDatabase : NSObject

+ (NSMutableArray *)loadWifiData;
+ (NSString *)nextWifiDataDocPath;

@end
