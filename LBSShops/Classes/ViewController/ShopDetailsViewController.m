    //
//  ShopDetailsViewController.m
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright 2010 sino. All rights reserved.
//

#import "LBSShopsAppDelegate.h"
#import "MapViewController.h"
#import "ShopDetailsViewController.h"
#import "CommentCell.h"

@implementation ShopDetailsViewController

@synthesize shop, tableView, tmpCommentCell, lblName, imgLogo;
@synthesize navCtrl, btnSign;


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

- (void) sign:(id)sender {
	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"反馈" message:@"签到成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alertView show];
	[alertView autorelease];
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void) updateInfo {

	UIColor * bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
	[self.view setBackgroundColor: bgColor];
	
	self.lblName.text = shop.name;
	self.imgLogo.image = [UIImage imageNamed: shop.imagename];
	
	[tableView reloadData];
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[navCtrl release];
	
    [super dealloc];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (section == 0) {
		
		return 3;
	} else {
		
		return 1;
	}
	
}

- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	int sec = [indexPath section];
	if (sec == 0) {
		return 44;
	} else {
		return 166;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tblView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier1 = @"shopDetailsCell";
	
	int sec = [indexPath section];
	
	if (sec == 0) {
		
		UITableViewCell *cell = [tblView dequeueReusableCellWithIdentifier:CellIdentifier1];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
		}
		
		int row = [indexPath row];
		if (row == 0) {
			cell.textLabel.text = shop.address;
		} else if (row == 1) {
			cell.textLabel.text = shop.telephone;
		} else {
			cell.textLabel.text = shop.discountInfo;
		}
		
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		return cell;
	} else {		
		static NSString *CellIdentifier2 = @"shopDetailsCell_commentcell";
		CommentCell *cell = (CommentCell *)[tblView dequeueReusableCellWithIdentifier: CellIdentifier2];
		if (cell == nil) {
			[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil];
			cell = tmpCommentCell;
			tmpCommentCell = nil;
			[cell autorelease];
		}
		
		cell.txtComment.text = shop.description;
		
		return cell;
	}
    // Configure the cell...
    
    return nil;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	int sec = [indexPath section];
	int row = [indexPath row];
	
	if (sec == 0) {
		if (row == 0) {
			MapViewController * mapCtrl = [[LBSShopsAppDelegate sharedAppDelegate] mapCtrl];
			NSMutableArray * arr = [NSMutableArray arrayWithCapacity:1];
			[arr addObject: self.shop];
			mapCtrl.shops = arr;
			[self.navCtrl pushViewController:mapCtrl animated:YES];			
		} else if (row == 1) {
			NSString *callToURLString = [NSString stringWithFormat:@"tel:%@", shop.telephone];
			if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:callToURLString]]) {
				// there was an error trying to open the URL. We'll ignore for the time being.
				UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error!"
																 message:@"Telephone call is not supported on this machine" delegate: self
													   cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[alert show];
				[alert autorelease];
			}
		}
	}
}

@end
