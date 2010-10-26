//
//  LBSShopsAppDelegate.h
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright sino 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

#import "LocationManager.h"
#import "ShopListViewController.h"
#import "ShopDetailsViewController.h"
#import "MapViewController.h"

@interface LBSShopsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    
    UIWindow *window;
    UITabBarController * tabCtrl;
	
	ShopListViewController *	shopListCtrl;
	ShopDetailsViewController * shopDetailsCtrl;
	MapViewController  * mapCtrl;
	
	LocationManager * locmgr;
	CLLocation * curLoc;
	
	UINavigationController * curNav;
}

+ (LBSShopsAppDelegate *) sharedAppDelegate;
- (void) locationManagerDidReceiveLocation:(LocationManager *)lm location:(CLLocation*)location;
- (void) locationManagerDidFail:(id)sender;
- (void)alert:(NSString*)title message:(NSString*)message;


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController * tabCtrl;
@property (nonatomic, retain) IBOutlet ShopListViewController *	shopListCtrl;
@property (nonatomic, retain) IBOutlet ShopDetailsViewController * shopDetailsCtrl;
@property (nonatomic, retain) IBOutlet MapViewController * mapCtrl;
@property (nonatomic, retain) CLLocation * curLoc;
@property (nonatomic, retain) LocationManager * locmgr;
@property (nonatomic, retain) IBOutlet UINavigationController * curNav;

@end

