//
//  ShopDetailsViewController.h
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright 2010 sino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopInfo.h"

@class CommentCell;
@interface ShopDetailsViewController : UIViewController  <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate> {
	ShopInfo * shop;
	
	UINavigationController  * navCtrl;

	UITableView * tableView;
	CommentCell * tmpCommentCell;
	UILabel		* lblName;
	UIImageView * imgLogo;
	
	UIButton    * btnSign;
}

- (IBAction) sign:(id)sender;
- (void) updateInfo ;

@property (nonatomic, retain) UINavigationController  * navCtrl;
@property (nonatomic, retain) ShopInfo * shop;
@property (nonatomic, retain) IBOutlet UITableView * tableView;
@property (nonatomic, retain) IBOutlet CommentCell * tmpCommentCell;
@property (nonatomic, retain) IBOutlet UILabel	   * lblName;
@property (nonatomic, retain) IBOutlet UIImageView * imgLogo;
@property (nonatomic, retain) IBOutlet UIButton    * btnSign;

@end
