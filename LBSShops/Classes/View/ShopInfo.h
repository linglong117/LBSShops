//
//  ShopInfo.h
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-15.
//  Copyright 2010 sino. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ShopInfo : NSObject {
	NSString * imagename;
	NSString * name;
	NSString * address;
	NSString * altitude;
	NSString * longitude;
	NSString * description;
	NSString * telephone;
	NSString * discountInfo;
	NSString * cardType;
	
	double  distance;
}

+ (NSArray *) nearShops:(CLLocation *)curLoc;
+ (NSArray *) allShops;

@property (nonatomic, retain) NSString * imagename;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * altitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * description;
@property (nonatomic, retain) NSString * telephone;
@property (nonatomic, retain) NSString * discountInfo;
@property (nonatomic, retain) NSString * cardType;
@property (nonatomic, readwrite) double distance;

@end
