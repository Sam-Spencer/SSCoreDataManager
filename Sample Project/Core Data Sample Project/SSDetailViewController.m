//
//  SSDetailViewController.m
//  Data Test
//
//  Created by Sam Spencer on 5/18/14.
//  Copyright (c) 2014 Sam Spencer. All rights reserved.
//

#import "SSDetailViewController.h"

@interface SSDetailViewController ()
- (void)configureView;
@end

@implementation SSDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"date"] description];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
