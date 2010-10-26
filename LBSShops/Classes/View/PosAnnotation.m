
#import "PosAnnotation.h"

@implementation PosAnnotation
@synthesize shop;

- (CLLocationCoordinate2D)coordinate {
    return coord;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
	coord = newCoordinate;
}

- (void)setShop:(ShopInfo *)s {
	if (shop != nil) {
		[shop release];
		shop = nil;
	}
	shop = s;
	[shop retain];
	
	CLLocation * loc = [[CLLocation alloc] initWithLatitude:[s.altitude doubleValue] longitude:[s.longitude doubleValue]];
	[loc autorelease];
	self.coordinate = loc.coordinate;
}

// required if you set the MKPinAnnotationView's "canShowCallout" property to YES
- (NSString *)title {
	if (shop != nil) {
		return shop.name;
	}
    return @"Your current position";
}

// optional
- (NSString *)subtitle {
	if (shop != nil)
		return shop.address;
    return @"Detected by GPS";
}

- (void)dealloc {
	[shop release];
	
    [super dealloc];
}

@end