//
//  NearViewController.h
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright 2010 sino. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NearViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UINavigationController  * navCtrl;
	
	UITableView * tableView;
	UIBarButtonItem * btnMapShow;
}

- (IBAction) mapShow:(id)sender;

@property (nonatomic, retain) IBOutlet UINavigationController * navCtrl;
@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem * btnMapShow;

@end
