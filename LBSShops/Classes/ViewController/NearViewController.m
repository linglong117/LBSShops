    //
//  NearViewController.m
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright 2010 sino. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "LBSShopsAppDelegate.h"
#import "NearViewController.h"

static NSArray * nearShops = nil;

@implementation NearViewController

@synthesize navCtrl, tableView, btnMapShow;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	CLLocation * curLoc = [[LBSShopsAppDelegate sharedAppDelegate] curLoc];
	
	if (nearShops != nil) {
		[nearShops release];
		nearShops = nil;
	}		
	
	nearShops = [ShopInfo nearShops: curLoc];
	[nearShops retain];
	
	
	[self.tableView reloadData];
}

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
    [super dealloc];
}

#pragma mark -
#pragma mark Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (nearShops == nil || [nearShops count] == 0) {
		@"附近没有找到商户";
	}
	return @"临近商户(1公里)";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
	if (nearShops == nil)
		return 0;
    return [nearShops count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"shoplistCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	ShopInfo * shop = [nearShops objectAtIndex:[indexPath row]];
	cell.imageView.image = [UIImage imageNamed: shop.imagename];
	cell.textLabel.text = shop.name;
	
	NSString * str = [NSString stringWithFormat:@"%@, %d米", shop.address, (int)shop.distance];
	cell.detailTextLabel.text = str;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
    // Configure the cell...
    
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	
	ShopDetailsViewController * shopDetailsCtrl = [[LBSShopsAppDelegate sharedAppDelegate] shopDetailsCtrl];
	
	shopDetailsCtrl.shop =  [nearShops objectAtIndex: [indexPath row]];
	[shopDetailsCtrl updateInfo];
	shopDetailsCtrl.navCtrl = self.navCtrl;
	[self.navCtrl pushViewController:shopDetailsCtrl animated:YES];
	
}


- (IBAction) mapShow:(id)sender {
	if (nearShops == nil || [nearShops count] == 0)
		return;
	
	MapViewController * mapCtrl = [[LBSShopsAppDelegate sharedAppDelegate] mapCtrl];
	mapCtrl.shops = nearShops;
	
	[self.navCtrl pushViewController:mapCtrl animated:YES];	
}

@end
