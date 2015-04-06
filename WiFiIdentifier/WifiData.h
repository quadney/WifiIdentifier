//
//  WifiData.h
//  WiFiIdentifier
//
//  Created by Sydney Richardson on 4/6/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiData : NSObject

@property (strong, nonatomic) NSString *libraryName;
@property (strong, nonatomic) NSMutableArray *wifiBSSIDCodes;

- (id)initWithName:(NSString *)name;

@end
