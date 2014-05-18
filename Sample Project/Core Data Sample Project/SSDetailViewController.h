//
//  SSDetailViewController.h
//  Data Test
//
//  Created by Sam Spencer on 5/18/14.
//  Copyright (c) 2014 Sam Spencer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SSDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
