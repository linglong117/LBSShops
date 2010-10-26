    //
//  SignViewController.m
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright 2010 sino. All rights reserved.
//

#import "SignViewController.h"
#import "MapViewController.h"
#import "LBSShopsAppDelegate.h"
#import "ShopInfo.h"

@implementation SignViewController

@synthesize navCtrl;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear: animated];
	
	NSArray * allShops = [ShopInfo allShops];
	ShopInfo * firstShop = [allShops objectAtIndex:0];
	double x = [[firstShop altitude] doubleValue];
	double y = [[firstShop longitude] doubleValue];
	NSMutableArray * shops = [NSMutableArray arrayWithCapacity:4];
	[shops addObject: firstShop];
	
	srand(time(0));
	for (int i=0; i<5; ++i) {
		ShopInfo * shop = [[[ShopInfo alloc] init] autorelease];
		
		shop.altitude = [NSString stringWithFormat:@"%lf", x + 0.001 * (rand()%21 - 10)];
		shop.longitude = [NSString stringWithFormat:@"%lf", y + 0.001 * (rand()%21 - 10)];
		shop.name = [NSString stringWithFormat:@"签到者:%d", i];
		shop.description = @"";
		shop.imagename = nil;
		
		[shops addObject: shop];
	}
	
	MapViewController * mapCtrl = [[LBSShopsAppDelegate sharedAppDelegate] mapCtrl];
	mapCtrl.shops = shops;
	
	[self.view addSubview: mapCtrl.view];
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
    [super dealloc];
}


@end
