//
//  CopyDataViewController.m
//  WiFiIdentifier
//
//  Created by Sydney Richardson on 4/6/15.
//  Copyright (c) 2015 Sydney Richardson. All rights reserved.
//

#import "CopyDataViewController.h"
#import "WifiDataStore.h"

@interface CopyDataViewController()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation CopyDataViewController

- (void)viewDidLoad {
    
    self.textView.text = [[[WifiDataStore sharedStore] libraryWifiObjects] description];
    
}

@end
