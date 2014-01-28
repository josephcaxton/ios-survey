//
//  SettingsViewController.m
//  Survey
//
//  Created by György Tóth on 09/10/2013.
//  Copyright (c) 2013 bbc. All rights reserved.
//

#import "SettingsViewController.h"
#import "ReachabilityManager.h"

@interface SettingsViewController ()

@property (nonatomic, strong) IBOutlet UIImageView *deviceIcon;
@property (nonatomic, strong) IBOutlet UIImageView *connectionIcon;
@property (nonatomic, strong) IBOutlet UIImageView *serviceIcon;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    ReachabilityManager *reachManager = [ReachabilityManager sharedManager];
    switch ([reachManager networkStatus]) {
        case 0:
            [self.connectionIcon setImage:[UIImage imageNamed:@"connection"]];
            break;

        default:
            break;
    }

    switch ([reachManager serviceStatus]) {
        case 0:
            [self.serviceIcon setImage:[UIImage imageNamed:@""]];
            break;

        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        NSString *mailString = [NSString stringWithFormat:@"mailto:%@", SUPPORT_EMAIL];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
    }

//    LogTrace(@"open VPN edge client");
//    NSURL *vpnAppUrl = [NSURL URLWithString:@"f5edgeclient://start?name=VPN%20Configuration%20%235114"];
//    [[UIApplication sharedApplication] openURL:vpnAppUrl];
}

- (IBAction)done:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
