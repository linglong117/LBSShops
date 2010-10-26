//
//  DataManger.h
//  MedicalApp
//
//  Created by yilong on 10-1-5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <CommonCrypto/CommonCryptor.h>

@class Reachability;

@interface DataManager : NSObject {
	sqlite3		*database;
	NSString	*databasePath;
	NSString *strDatabasePath;
	NSString *strDatabasePath0;
	
	Reachability *hostReach;
    Reachability *internetReach;
    Reachability *wifiReach;
}

+ (id)sharedManager;

- (NSMutableArray *) getAllContacts;

- (NSString *)databaseFullPath;
- (BOOL)prepareDatabase;

-(NSString *)stringReplacing:(NSString *)strSource;

//判断网络是否可用
- (NSInteger)doNetworkReachability;
- (NSInteger)doNetworkServerUrl:(NSString *)urlPath;

-(NSInteger)doSaveRoot:(NSArray *)arrayData;
//-(NSArray *)getDocumentList;	//获得某一功能的报文列表
-(NSMutableArray *)getDocumentList:(NSString *)documentType state:(NSInteger)documentState;	//获得某一功能的报文列表

-(NSInteger)doSaveDocId:(NSArray *)arrayData;
-(NSArray *)getDocIdList;
-(NSInteger)alterDocIdState:(NSMutableArray *)arrayData;


-(NSInteger)doSaveFieldList:(NSArray *)arrayData;

-(NSInteger)alterDocumentState:(NSString *)strDocumentType documentId:(NSString *)strDocumentId  state:(NSString *)state;

-(NSInteger)saveOpinionValue:(NSString *)infoId opinionValue:(NSString *)opinionValue;
-(NSInteger)saveOptionValue:(NSString *)infoId optionValue:(NSMutableArray *)arrayData;

-(NSArray *)getSubmitList:(NSString *)strDocumentId;

//-(NSArray *)getAbstractFieldList;//得到field 字段列表 摘要部分的内容
-(NSArray *)getAbstractFieldList:(NSString *)strDocumentId;
//-(NSArray *)getMainBodyData; //得到正文内容
-(NSArray *)getMainBodyData:(NSString *)strDocumentId;
-(NSArray *)getOpinionData:(NSString *)strDocumentId;//获得意见部分的内
-(NSArray *)getOpinionDataList:(NSString *)strDocumentId layoutId:(NSString *)layoutId;//获得意见部分的内

-(NSArray *)getAttachmentData:(NSString *)strDocumentId; //获得附件的内容

- (NSDate *)createDateWith:(int *)year :(int *)month :(int *)day;
- (UIImage *)createRoundedRectImage:(UIImage*)image size:(CGSize)size;
-(NSString *)md5:(NSString *)str;

//lbs
- (NSInteger)insertShop:(NSMutableArray *)shopArray;
-(NSMutableArray *)getShopsData;

@end
