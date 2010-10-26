#import "MapViewController.h"
#import "PosAnnotation.h"
#import "TheAnnotationView.h"

@implementation MapViewController

@synthesize mapView, shops, theAnnotations;

- (void)viewDidLoad
{	
    // go to North America
    MKCoordinateRegion newRegion;
    newRegion.center.latitude = 37.37;
    newRegion.center.longitude = -96.24;
    newRegion.span.latitudeDelta = 1; // 28.49;
    newRegion.span.longitudeDelta = 1; // 31.025;

	[self.mapView setShowsUserLocation: NO];
	
    [self.mapView setRegion:newRegion animated: YES];
}

- (void) setShops:(NSArray *)ss {
	if (shops != nil) {
		[shops release];
		shops = nil;
	}
	shops = ss;
	[shops retain];
	
	NSMutableArray * annotations = [NSMutableArray arrayWithCapacity:4];
	double lat_c = 0.0;
	double log_c = 0.0;
	for (ShopInfo *shop in shops){
		lat_c += [shop.altitude doubleValue];
		log_c += [shop.longitude doubleValue];
		
		PosAnnotation * anno = [[[PosAnnotation alloc] init] autorelease];
		anno.shop = shop;
		[annotations addObject: anno];
	}
	lat_c /= [ss count];
	log_c /= [ss count];
	
	CLLocation * location = [[CLLocation alloc] initWithLatitude:lat_c longitude:log_c];
	[location autorelease];
	
	MKCoordinateRegion newRegion;
    newRegion.center = location.coordinate;
	
    newRegion.span.latitudeDelta = 0.05; // 28.49;
    newRegion.span.longitudeDelta = 0.05; // 31.025;
		
    [self.mapView setRegion:newRegion animated: YES];	
	
	NSArray *oldAnnotations = mapView.annotations;
    [mapView removeAnnotations:oldAnnotations];	

	[mapView addAnnotations: annotations];
	// [mapView setSelectedAnnotations: annotations];
	self.theAnnotations = annotations;
}

- (void) mapViewDidFinishLoadingMap:(MKMapView *)mp {

	[mp setSelectedAnnotations: self.theAnnotations];
}										


- (void)dealloc {
    [mapView release];
	[shops release];
	[theAnnotations release];
	
    [super dealloc];
}


#pragma mark Map View Delegate methods

/*
- (void)mapView:(MKMapView *)map regionDidChangeAnimated:(BOOL)animated
{
    NSArray *oldAnnotations = mapView.annotations;
    [mapView removeAnnotations:oldAnnotations];
 
	if (isGPS) {
		PosAnnotation * anno = [[[PosAnnotation alloc] init] autorelease];
		[anno setCoordinate: gpsPos];
		[mapView addAnnotation: anno];
	} else {
		NSArray *weatherItems = [weatherServer weatherItemsForMapRegion:mapView.region maximumCount:4];
		[mapView addAnnotations:weatherItems];
	}
}*/

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
 	
	static NSString* BridgeAnnotationIdentifier = @"theAnnotationIdentifier";
	MKPinAnnotationView * pinView = (MKPinAnnotationView *)
	[mapView dequeueReusableAnnotationViewWithIdentifier:BridgeAnnotationIdentifier];
	if (!pinView) {
		// if an existing pin view was not available, create one
		MKPinAnnotationView* customPinView = [[[MKPinAnnotationView alloc]
											   initWithAnnotation:annotation reuseIdentifier:BridgeAnnotationIdentifier] autorelease];
		customPinView.animatesDrop = YES;
		PosAnnotation * anno = (PosAnnotation*) annotation;
		if (anno.shop.imagename != nil) {
			customPinView.pinColor = MKPinAnnotationColorPurple;
		} else {
			customPinView.pinColor = MKPinAnnotationColorRed;
		}
		customPinView.canShowCallout = YES;
		customPinView.annotation = annotation;
		customPinView.rightCalloutAccessoryView = nil; //rightButton;

		return customPinView;
	} else {
		pinView.annotation = annotation;
		PosAnnotation * anno = (PosAnnotation*) annotation;
		if (anno.shop.imagename != nil) {
			pinView.pinColor = MKPinAnnotationColorPurple;
		} else {
			pinView.pinColor = MKPinAnnotationColorRed;
		}
	}   
    
    return pinView;
}

@end
