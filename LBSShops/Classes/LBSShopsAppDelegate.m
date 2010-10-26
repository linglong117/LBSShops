//
//  LBSShopsAppDelegate.m
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright sino 2010. All rights reserved.
//

#import "LBSShopsAppDelegate.h"

static LBSShopsAppDelegate * appDelegate = nil;
static UIAlertView * sAlert;

@implementation LBSShopsAppDelegate

@synthesize window;
@synthesize tabCtrl, shopListCtrl, shopDetailsCtrl;
@synthesize curLoc, locmgr, mapCtrl, curNav;


+ (LBSShopsAppDelegate *) sharedAppDelegate {
	return appDelegate;
}

- (void) locationManagerDidReceiveLocation:(LocationManager *)lm
								  location:(CLLocation*)location {
	self.curLoc = location;
}

- (void) locationManagerDidFail:(id)sender {
}

- (void)alert:(NSString*)title message:(NSString*)message {
	if (sAlert) 
	   return;
    sAlert = [[UIAlertView alloc] initWithTitle:title
                                        message:message
									   delegate:self
							  cancelButtonTitle:@"Close"
							  otherButtonTitles:nil];
    [sAlert show];
    [sAlert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonInde
{
    sAlert = nil;
}


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    appDelegate = self;
    // Override point for customization after application launch.
    
    // Add the navigation controller's view to the window and display.
    [window addSubview: tabCtrl.view];
    [window makeKeyAndVisible];
	
	curLoc = [[CLLocation alloc] initWithLatitude:0.0 longitude: 0.0];
	locmgr = [[LocationManager alloc] initWithDelegate: self];

	[locmgr getCurrentLocation];
	
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[locmgr getCurrentLocation];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[tabCtrl release];
	[window release];
	
	[curNav release];
	
	[super dealloc];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	if (self.curNav != nil && self.curNav != viewController) {
		[self.curNav popToRootViewControllerAnimated: YES];
	}
	
	self.curNav = (UINavigationController*) viewController;
	
	return YES;
}

@end

