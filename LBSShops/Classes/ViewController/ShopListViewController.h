//
//  ShopListViewController.h
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright 2010 sino. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShopListViewController : UITableViewController {
	NSArray * shops;
	
	UINavigationController  * navCtrl;
}

@property (nonatomic, retain) NSArray * shops;
@property (nonatomic, retain) UINavigationController  * navCtrl;


@end
