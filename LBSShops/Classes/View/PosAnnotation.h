
#import <MapKit/MapKit.h>

#import "ShopInfo.h"

@interface PosAnnotation : NSObject <MKAnnotation>
{
	ShopInfo * shop;
	CLLocationCoordinate2D coord;
}

@property (nonatomic, retain) ShopInfo * shop;

@end