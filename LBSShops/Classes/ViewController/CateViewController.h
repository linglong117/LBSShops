//
//  CateViewController.h
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright 2010 sino. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CateViewController : UIViewController<UITableViewDelegate, UITableViewDataSource> {
	UINavigationController  * navCtrl;
	UITableView             * tableView;
}

@property (nonatomic, retain) IBOutlet UINavigationController * navCtrl;
@property (nonatomic, retain) IBOutlet UITableView            * tableView;


@end
