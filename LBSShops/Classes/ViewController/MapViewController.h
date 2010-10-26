
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ShopInfo.h"

@interface MapViewController : UIViewController <MKMapViewDelegate>
{
    MKMapView *mapView;
	// ShopInfo * shop;
	NSArray * shops;
	NSArray * theAnnotations;
}

@property (nonatomic, retain) IBOutlet MKMapView *mapView;
// @property (nonatomic, retain) IBOutlet ShopInfo  * shop;
@property (nonatomic, retain) NSArray  * shops;
@property (nonatomic, retain) NSArray * theAnnotations;

@end
