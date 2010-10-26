//
//  DataManger.m
//  MedicalApp
//
//  Created by yilong on 10-1-5.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DataManager.h"
#import "predfin.h"
#import "Reachability.h"
//ABAddressBook.h
#import <AddressBook/AddressBook.h>
#import <CommonCrypto/CommonCryptor.h>
#import <sqlite3.h>
#import <CommonCrypto/CommonDigest.h>
#import "JSON.h"
#import "ShopInfo.h"


@implementation DataManager


//
+ (id)sharedManager{
	//
	static id sharedManager = nil;
	if(sharedManager == nil){
		sharedManager = [[self alloc] init];
	}
	return sharedManager;
	//
}

- (id)init{
	if (self = [super init]) {
		[self prepareDatabase];
		//
	}
	return self;
}

#pragma mark Database Method

- (NSString *)databaseFullPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *_databaseFullPath = [documentsDirectory stringByAppendingPathComponent:kDatabaseName];

	//strDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"gtfund0.sqlite"];
	//strDatabasePath0 = [documentsDirectory stringByAppendingPathComponent:@"gtfund1.sqlite"];

	return _databaseFullPath;
}

- (BOOL)prepareDatabase{
	//
	//databaseName = @"Medical";
	
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
	NSString *_databaseFullPath = [self databaseFullPath];
	databasePath = [[NSString alloc] initWithString:_databaseFullPath];
	//databasePath = _databaseFullPath;
		
    success = [fileManager fileExistsAtPath:_databaseFullPath];
	if (success){ 
		//NSError *error = nil;
		/*
		if (![[NSFileManager defaultManager] AESEncryptFile:databasePath toFile:strDatabasePath usingPassphrase:@"11111111" error:&error])
		{
			NSLog(@"Failed to write encrypted file. Error = %@", [[error userInfo] objectForKey:AESEncryptionErrorDescriptionKey]);
		}
		 */
		return success;
	}
	
	// The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDatabaseName];

	//success = [fileManager fileExistsAtPath:_databaseFullPath];
	
	success = [fileManager copyItemAtPath:defaultDBPath toPath:_databaseFullPath error:&error];
	
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		return FALSE;
    }else {
		/*
		if (![[NSFileManager defaultManager] AESEncryptFile:defaultDBPath toFile:strDatabasePath usingPassphrase:@"11111111" error:&error])
		{
			NSLog(@"Failed to write encrypted file. Error = %@", [[error userInfo] objectForKey:AESEncryptionErrorDescriptionKey]);
		}*/
		return success;
	}

	
}

//
//
- (NSInteger)doNetworkReachability{
	//sleep(1);
	//判断iphone 的网络状态
	if((NotReachable == [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] ) && (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus])){
		//网络有问题，给出提示
		NSLog(@"no network connection");
		/*
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Note" 
														 message:@"Network not available: You must be connected to the internet for this function to work correctly." 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];
		[alert show];
		 */
		return -1;
	}else {
		return 1;
	}
}



- (NSInteger)doNetworkServerUrl:(NSString *)urlPath{
	//判断iphone 的网络状态
	if((NotReachable == [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] ) && (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus])){
		//网络有问题，给出提示
		NSLog(@"no network connection");
		/*
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"note" 
														 message:@"Error!" 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];
		[alert show];
		 */
		return -1;
	}else{
		//NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",urlPath]];
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kServerUrl]];
		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
		[request setHTTPMethod:@"POST"];
		[request setTimeoutInterval:11];
		//
		NSURLResponse *reponse;
		NSError *error = nil;
		//NSString *responseString = nil;
		NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
		[request release];
		if (error) {
			NSLog(@"Something wrong: %@",[error description]);
			/*
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"note" 
															 message:@"Connection failed!" 
															delegate:self 
												   cancelButtonTitle:@"OK" 
												   otherButtonTitles:nil] autorelease];
			[alert show];
			 */
			return -1;
		}else {
			if (responseData) {
				//responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
				//[NSThread detachNewThreadSelector:@selector(doDataSyncTask) toTarget:self withObject:nil];
				return 1;
			}else {
				/*
				UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"note" 
																 message:@"Time out!" 
																delegate:self 
													   cancelButtonTitle:@"OK" 
													   otherButtonTitles:nil] autorelease];
				[alert show];
				 */
				return -1;
			}
		}
	}
}




/*
 '用''代替
 */
-(NSString *)stringReplacing:(NSString *)strSource{
	strSource = [strSource stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
	return strSource;
}


//===============国泰基金===============================

//保存报文的title 信息, 报文的type 、name 、id、brief
-(NSInteger)doSaveRoot:(NSArray *)arrayData{ 
	
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can't open the database.");
		return -1;
	}
	//
	if([arrayData count] <= 0){
		NSLog(@"arrayData is empty.");
		return -1;
	}
	
	//NSInteger t = sqlite3_key(database,"1q2w3e4r",8);
	
	int resultUpdatetblLab;
	//
	
	NSString *strType = [arrayData objectAtIndex:0];
	NSString *strKind = [arrayData objectAtIndex:1];
	NSString *strBrief = [arrayData objectAtIndex:2];
	NSString *strId = [arrayData objectAtIndex:3];
	
	
	sqlite3_stmt *stmt;
	NSString *strSelect = [NSString stringWithFormat:@"select documentId from tblDocumentList where documentId = '%@'",strId];
	//NSLog(@"delete sql :%@",strDelete);
	char *ssql = (char *) [strSelect UTF8String];
	//char *_merror = nil;
	sqlite3_prepare_v2(database, ssql, -1, &stmt, NULL);
	int result = sqlite3_step(stmt);
	if(result == SQLITE_ROW){
		char *c;
		c  = (char *)sqlite3_column_text(stmt, 0);
		NSString *s = [NSString stringWithUTF8String:c];
		if ([s isEqualToString:strId]) {
			sqlite3_finalize(stmt);
			sqlite3_close(database);
			return SQLITE_ExistRow;//
		}
	}
	
	NSDate *now = [NSDate date];
	NSString *nowtime = [now description];
	//NSLog(@"root nowtime %@",nowtime);
	NSString *s;
	
	NSInteger maxId =0;
	//
	
	//sqlite3_stmt *stmt;
	char *sql;
	sql = "select max(id) from tblDocumentList";
	sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
	int code = sqlite3_step(stmt);
	if (code == SQLITE_ROW) {
		int n = sqlite3_column_int(stmt, 0);
		maxId = n+1;
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	
	NSString *ssql1 = [NSString stringWithFormat:
					   @"insert into tblDocumentList(id,DocumentId,DocumentType,DocumentName,DocumentState,"
					   "DocumentBrief,time) values(%d,'%@','%@','%@',%d,'%@','%@')",
					   maxId,strId,strType,strKind,0,strBrief,nowtime];
	
	s = [[NSString alloc] initWithUTF8String:[ssql1 UTF8String]];
	NSLog(@"insert sql: %@",s);
	
	char *msql = (char *) [s UTF8String];
	char *merror = nil;
	//int resultUpdatetblChangeLog = sqlite3_exec(database, msql, 0, 0,&merror);
	resultUpdatetblLab = sqlite3_exec(database, msql, 0, 0,&merror);
	 // NSString *string = [NSString stringWithCString:tmp];
	if (merror) {
		NSLog(@"Failed to update");
		//NSLog(@"%@", [NSString stringWithCString:merror]);
		NSLog(@"result = %d",resultUpdatetblLab);
		sqlite3_close(database);
		[s release];
		return -1;
	}else {
		if(resultUpdatetblLab != SQLITE_OK){
			NSLog(@" sql: %@" ,s);
			NSLog(@"result = %d",resultUpdatetblLab);
			sqlite3_close(database);
			[s release];
			return -1;
		}
		
	}
	[s release];
	NSLog(@"m = %d",resultUpdatetblLab);
	sqlite3_close(database);
	return resultUpdatetblLab;
}
//
-(NSInteger)doSaveDocId:(NSArray *)arrayData{
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can't open the database.");
		return -1;
	}
	//
	if([arrayData count] <= 0){
		NSLog(@"arrayData is empty.");
		return -1;
	}
	
	int result;
	NSString *strDelete = [NSString stringWithFormat:@"delete from tblDocIdList"];
	 NSLog(@"delete sql :%@",strDelete);
	 char *msqlDelete = (char *) [strDelete UTF8String];
	 char *merror = nil;
	 int resultDelete = sqlite3_exec(database, msqlDelete, 0, 0,&merror);
	 
	 if(resultDelete != SQLITE_OK){
		 return -1;
	 }
	//
	NSLog(@"%@",[arrayData description]);
	for (int i=0; i<[arrayData count]; i++) {
		NSMutableDictionary *dic = [arrayData objectAtIndex:i];
		
		NSString *strDocId = [dic objectForKey:@"docId"];
		NSString *strType = [dic objectForKey:@"operateType"];
		NSInteger type = [strType integerValue];
		
		NSDate *now = [NSDate date];
		NSString *nowtime = [now description];
		NSString *s;
		NSInteger maxId =0;
		//
		sqlite3_stmt *stmt;
		char *sql;
		sql = "select max(id) from tblDocIdList";
		
		//判断数据是否已经打开
		int n = sqlite3_open([databasePath UTF8String], &database);
		if(n != SQLITE_OK){
			NSLog(@"can't open the database.");
			return -1;
		}
		
		sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
		int code = sqlite3_step(stmt);
		if (code == SQLITE_ROW) {
			int n = sqlite3_column_int(stmt, 0);
			maxId = n+1;
			code = sqlite3_step(stmt);
		}
		sqlite3_finalize(stmt);
		
		NSString *ssql1 = [NSString stringWithFormat:
						   @"insert into tblDocIdList(id,docId,type,time,state) values(%d,'%@','%@','%@','0')",
						   maxId,strDocId,strType,nowtime];
		
		s = [[NSString alloc] initWithUTF8String:[ssql1 UTF8String]];
		NSLog(@"insert sql: %@",s);
		
		char *msql = (char *) [s UTF8String];
		char *merror = nil;
		//int resultUpdatetblChangeLog = sqlite3_exec(database, msql, 0, 0,&merror);
		result = sqlite3_exec(database, msql, 0, 0,&merror);
		// NSString *string = [NSString stringWithCString:tmp];
		if (merror) {
			NSLog(@"Failed to update");
			//NSLog(@"%@", [NSString stringWithCString:merror]);
			NSLog(@"result = %d",result);
			sqlite3_close(database);
			[s release];
			return -1;
		}else {
			if(result != SQLITE_OK){
				NSLog(@" sql: %@" ,s);
				NSLog(@"result = %d",result);
				sqlite3_close(database);
				[s release];
				return -1;
			}
		}
		[s release];
		NSLog(@"m = %d",result);
		
		switch (type) {
			case 0:{
				//新增公文
				NSLog(@"cc");
			}
				break;
			case 1:{
				//删除公文tblDocumentList  tblField
				NSArray *docIdArray = [strDocId componentsSeparatedByString:@"&"];
				NSString *strDelete = [NSString stringWithFormat:@"delete from tblDocumentList where DocumentId='%@' ",[docIdArray objectAtIndex:0]];
				NSLog(@"delete sql :%@",strDelete);
				char *msqlDelete = (char *) [strDelete UTF8String];
				char *merror = nil;
				int resultDelete = sqlite3_exec(database, msqlDelete, 0, 0,&merror);
				
				if(resultDelete != SQLITE_OK){
					//NSLog(@" sql: %@" ,s);
					return -1;
				}
				//
				strDelete = [NSString stringWithFormat:@"delete from tblField where DocumentId='%@' ",[docIdArray objectAtIndex:0]];
				NSLog(@"delete sql :%@",strDelete);
				char *_msqlDelete = (char *) [strDelete UTF8String];
				resultDelete = sqlite3_exec(database, _msqlDelete, 0, 0,&merror);
				
				if(resultDelete != SQLITE_OK){
					//NSLog(@" sql: %@" ,s);
					return -1;
				}
			}
				break;
			case 2:{
				//提交成功
				NSArray *docIdArray = [strDocId componentsSeparatedByString:@"&"];
				
				/*
				NSString *strDocId = [dic objectForKey:@"docId"];
				NSString *ssql1 = [NSString stringWithFormat:@"update tblDocIdList set type='%@' ",strType];
				NSString *ssql2 = [NSString stringWithFormat:@" where docId='%@'",strDocId];
				//NSString *ssql2 = [NSString stringWithFormat:@" where documentType='%@' and documentId = '%@' and id=%d" ,strDocumentType,strDocumentId,i_id];
				
				NSString *ssql = [ssql1 stringByAppendingString:ssql2];
				NSString *s = [[NSString alloc] initWithUTF8String:[ssql UTF8String]];
				char *msql = (char *) [s UTF8String];
				char *merror = nil;
				//int resultUpdatetblChangeLog = sqlite3_exec(database, msql, 0, 0,&merror);
				result = sqlite3_exec(database, msql, 0, 0,&merror);
				
				if(result != SQLITE_OK){
					NSLog(@" sql: %@" ,s);
					NSLog(@"r = %d",result);
					sqlite3_close(database);
					return -1;
				}
				//NSLog(@"update sql: %@",ssql);
				NSLog(@"m = %d",result);
				if (merror) {
					return -1;
				}*/
				//当状态为0(未读)时,更改状态为1(已读)
				NSInteger resultFlag = [[DataManager sharedManager] alterDocumentState:@"" documentId:[docIdArray objectAtIndex:0]  state:@"5"];
				
				if (resultFlag==0) {
					NSLog(@"OK"); 
				}else {
				}
			}
				break;
			case 3:{
				//提交失败
				/*
				NSArray *docIdArray = [strDocId componentsSeparatedByString:@"&"];
				//当状态为0(未读)时,更改状态为1(已读)
				NSInteger resultFlag = [[DataManager sharedManager] alterDocumentState:@"" documentId:[docIdArray objectAtIndex:0]  state:@"3"];
				
				if (resultFlag==0) {
					NSLog(@"OK"); 
				}else {
				}*/
			}
				break;
			default:
				break;
		}
		
		/*
		sqlite3_stmt *_stmt;
		NSString *strSelect = [NSString stringWithFormat:@"select docId from tblDocIdList where docId = '%@'",strDocId];
		//NSLog(@"delete sql :%@",strDelete);
		char *ssql = (char *) [strSelect UTF8String];
		//char *_merror = nil;
		sqlite3_prepare_v2(database, ssql, -1, &_stmt, NULL);
		int result = sqlite3_step(_stmt);
		if(result == SQLITE_ROW){
			char *c;
			c  = (char *)sqlite3_column_text(_stmt, 0);
			NSString *s = [NSString stringWithUTF8String:c];
			if ([s isEqualToString:strDocId]) {
				sqlite3_finalize(_stmt);
				sqlite3_close(database);
				return SQLITE_ExistRow;//
			}
		}*/
	}
	sqlite3_close(database);
	return result;
}

//获到docId  数据 
-(NSArray *)getDocIdList{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	// >>>>> 
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can not open the database");
		return [array autorelease];
	}
	sqlite3_stmt *stmt;
	//char *sql = "select id,layoutid,layoutType,viewId,viewType,viewLabel,viewMsg,viewTime from tblField order by viewTime desc";
	//char *sql = "select id,documentType,documentId,layoutId,layoutType,layoutVisible,viewId,viewType,viewLabel,viewValue,viewDepartment,viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zyxx%'";
	NSString *sql =[NSString stringWithFormat:@"select id,docId,type,time,state from tblDocIdList where state='0'"];
	
	char *msql = (char *) [sql UTF8String];
	sqlite3_prepare_v2(database, msql, -1, &stmt, NULL);
	int  code = sqlite3_step(stmt);
	while (code == SQLITE_ROW) {
		
		NSMutableDictionary *d;
		d = [[NSMutableDictionary alloc] init];
		char *c;
		NSString *s;
		//int n = sqlite3_column_int(stmt, 0);
		//[d setObject:[NSNumber numberWithInt:n] forKey:@"id"];
		//
		c  = (char *)sqlite3_column_text(stmt, 1);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"docId"];
		//
		c  = (char *)sqlite3_column_text(stmt, 2);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"type"];
		
		[array addObject:d];
		[d release];
		//
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	sqlite3_close(database);
	return [array autorelease];
}


//修改tblDocIdList 报文请求是否成功的状态
-(NSInteger)alterDocIdState:(NSMutableArray *)arrayData{
	
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can't open the database.");
		return -1;
	}
	//NSDate *now = [NSDate date];
	//NSLog(@"%@",[now description]);
	//NSString *nowtime = [now description];
	int resultUpdatetblLab;
	
	for (int i=0; i<[arrayData count]; i++) {
		
		NSMutableDictionary *dic = [arrayData objectAtIndex:i];
		NSString *strDocId = [dic objectForKey:@"docId"];
		NSString *ssql1 = [NSString stringWithFormat:@"update tblDocIdList set state='1' "];
		NSString *ssql2 = [NSString stringWithFormat:@" where docId='%@'",strDocId];
		//NSString *ssql2 = [NSString stringWithFormat:@" where documentType='%@' and documentId = '%@' and id=%d" ,strDocumentType,strDocumentId,i_id];
		
		NSString *ssql = [ssql1 stringByAppendingString:ssql2];
		NSString *s = [[NSString alloc] initWithUTF8String:[ssql UTF8String]];
		char *msql = (char *) [s UTF8String];
		char *merror = nil;
		//int resultUpdatetblChangeLog = sqlite3_exec(database, msql, 0, 0,&merror);
		resultUpdatetblLab = sqlite3_exec(database, msql, 0, 0,&merror);
		
		if(resultUpdatetblLab != SQLITE_OK){
			NSLog(@" sql: %@" ,s);
			NSLog(@"r = %d",resultUpdatetblLab);
			sqlite3_close(database);
			return -1;
		}
		//NSLog(@"update sql: %@",ssql);
		NSLog(@"m = %d",resultUpdatetblLab);
		if (merror) {
			return -1;
		}
	}
	sqlite3_close(database);
	return resultUpdatetblLab;
}




//得到报文列表
/*
 documentType:某一类报文的type
 documnetState:是取全部的报文(-1),还是只取未读的(0)
 */
-(NSMutableArray *)getDocumentList:(NSString *)documentType state:(NSInteger)documentState{
	
	NSMutableArray *array = [[NSMutableArray alloc] init];
	// >>>>> 
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can not open the database");
		return [array autorelease];
	}
	sqlite3_stmt *stmt;
	NSString *strSelect;
	if (documentState==-1) {
		strSelect = [NSString stringWithFormat:@"select id,DocumentId,DocumentType,DocumentName,DocumentState,DocumentBrief,time from tblDocumentList where documentState!=4 and DocumentType='%@' order by time desc",documentType];
	}else  if(documentState==0){
		strSelect = [NSString stringWithFormat:@"select id,DocumentId,DocumentType,DocumentName,DocumentState,DocumentBrief,time from tblDocumentList where documentState=0 and DocumentType='%@' order by time desc",documentType];
	}
	
	char *sql = (char *)[strSelect UTF8String];
	sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
	int  code = sqlite3_step(stmt);
	while (code == SQLITE_ROW) {
		
		NSMutableDictionary *d;
		d = [[NSMutableDictionary alloc] init];
		char *c;
		NSString *s;
		int n = sqlite3_column_int(stmt, 0);
		[d setObject:[NSNumber numberWithInt:n] forKey:kName_id];
		
		c  = (char *)sqlite3_column_text(stmt, 1);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kDocumentId];
		//[s release];
		//
		c  = (char *)sqlite3_column_text(stmt, 2);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewLabel %@",s);
		[d setObject:s forKey:kDocumentType];

		//
		c  = (char *)sqlite3_column_text(stmt, 3);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"DocumentName %@",s);
		[d setObject:s forKey:kDocumentName];
		//[s release];
		//
		n = sqlite3_column_int(stmt, 4);
		[d setObject:[NSNumber numberWithInt:n] forKey:kDocumentState];
		
		//
		c  = (char *)sqlite3_column_text(stmt, 5);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewTime %@",s);
		[d setObject:s forKey:kDocumentBrief];
		//[s release];
		//
		c  = (char *)sqlite3_column_text(stmt, 6);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewTime %@",s);
		[d setObject:s forKey:kDocumentTime];
		//
		/*
		c = (char *)sqlite3_column_text(stmt, 7);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kInfoId];
		 */
		//
		[array addObject:d];
		[d release];
		//
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	sqlite3_close(database);
	return [array autorelease];
}

/*
 set a breakpoint in malloc_error_break to debug
 GtFund(1097,0xa0980500) malloc: *** error for object 0x78211d8: Non-aligned pointer being freed
 */

//保存报文详细信息
-(NSInteger)doSaveFieldList:(NSArray *)arrayData{ 
	
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can't open the database.");
		return -1;
	}
	//sqlite3_stmt *stmt;
	//update tblLab set IsStarred=1 where labName='Osmolality' and labId=4
	if([arrayData count] <= 0){
		NSLog(@"arrayData  is empty.");
		return -1;
	}
	
	//tblField 表中字段值
	//select id,documentId,documentType,layoutId,layoutType,viewId,viewType,viewLabel,viewSubmit,
	//viewVisible,viewMsg,viewTime from tblfield
	sqlite3_stmt *stmt;
	int result;
	NSInteger count = 0;
	
	NSString *strRootType = [arrayData objectAtIndex:0];
	NSString *strDocumentId = [arrayData objectAtIndex:1];
	NSString *strInfoId = [arrayData objectAtIndex:2];
	NSString *strInfoId_1=@"";
	
	NSString *strDelete = [NSString stringWithFormat:@"delete from tblfield where infoId='%@'",strInfoId];
	//NSLog(@"delete sql :%@",strDelete);
	char *msqlDelete = (char *) [strDelete UTF8String];
	char *merror = nil;
	int resultDelete = sqlite3_exec(database, msqlDelete, 0, 0,&merror);

	if (merror) {
		NSLog(@"Failed to update");
		//NSLog(@"%@", [NSString stringWithCString:merror]);
		sqlite3_close(database);
		return -1;
	}
	
	if(resultDelete != SQLITE_OK){
		NSLog(@" sql: %@ ,resultDelete: %d" ,strDelete,resultDelete);
		sqlite3_close(database);
		return -1;
	}
	//sqlite3_finalize(stmt);
	
	//
	
	for (int i=3; i<[arrayData count]; i++) {
		NSDictionary *dicData = [arrayData objectAtIndex:i];
		
		
		NSString *strLayoutId = [dicData objectForKey:kName_layoutId];
		if ([strLayoutId isEqualToString:kNull]) {
			strLayoutId = @"";
		}
		
		NSString *strLayoutType = [dicData objectForKey:kName_layoutType];
		if ([strLayoutType isEqualToString:kNull]) {
			strLayoutType = @"";
		}
		
		NSString *strLayoutVisible = [dicData objectForKey:kName_layoutVisible];
		if ([strLayoutVisible isEqualToString:kNull]) {
			strLayoutVisible = @"";
			//NSLog(@"strLayoutVisible %@",strLayoutVisible);
			//strLayoutVisible= [[NSString alloc] initWithString:@""];
		}
		//
		NSString *strViewType = [dicData objectForKey:kName_viewType];
		if ([strViewType isEqualToString:kNull]) {
			strViewType = @"";
		}else if ([strViewType isEqualToString:@"link"]) {
			count++;
			strInfoId_1 = [strDocumentId stringByAppendingFormat:@"-%d",count];
		}
	
		//
		NSString *strViewLabel = [dicData objectForKey:kName_viewLabel];
		if ([strViewLabel isEqualToString:kNull]) {
			strViewLabel = @"";
		}
		
		NSString *strViewValue = [dicData objectForKey:kName_viewValue];
		if ([strViewValue isEqualToString:kNull]) {
			strViewValue = @"";
		}
		NSString *strViewId = [dicData objectForKey:kName_viewId];
		if ([strViewId isEqualToString:@""]) {
			strViewId = @"";
		}
		
		NSString *strViewUId = [dicData objectForKey:kName_viewUid];
		if ([strViewUId isEqualToString:@""]) {
			strViewUId = @"";
		}
		
		
		NSString *strViewSubmit = [dicData objectForKey:kName_viewSubmit];
		if ([strViewSubmit isEqualToString:kNull]) {
			strViewSubmit = @"";
		}
		
		NSString *strViewVisible = [dicData objectForKey:kName_viewVisible];
		if ([strViewVisible isEqualToString:kNull]) {
			strViewVisible = @"";
		}
		NSString *strViewDepartment = [dicData objectForKey:kName_viewDepartment];
		if ([strViewDepartment isEqualToString:kNull]) {
			strViewDepartment = @"";
		}
		NSString *strViewMulti = [dicData objectForKey:kName_viewMulti];
		if ([strViewMulti isEqualToString:kNull]) {
			strViewMulti = @"";
		}
		
		NSString *strViewNodeName = [dicData objectForKey:kName_viewNodeName];
		if ([strViewNodeName isEqualToString:kNull]) {
			strViewNodeName = @"";
		}
		
		
		NSString *strViewReadOnly = [dicData objectForKey:kName_viewReadonly];
		if ([strViewReadOnly isEqualToString:kNull]) {
			strViewReadOnly = @"";
		}
		
		NSString *strViewOnChange = [dicData objectForKey:kName_ViewOnchange];
		strViewOnChange = [strViewOnChange stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
		if ([strViewOnChange isEqualToString:kNull]) {
			strViewOnChange = @"";
		}else {
			NSLog(@"strViewOnChange %@",strViewOnChange);
		}

		
		
		
		NSDate *now = [NSDate date];
		//NSLog(@"%@",[now description]);
		NSString *nowtime = [now description];
		//NSLog(@"lala nowtime %@",nowtime);
		/*
		 NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		 [formatter setDateFormat:@"yyyy"];
		 //Optionally for time zone converstions
		 [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
		 NSString *stringFromDate = [formatter stringFromDate:now];
		 */
		NSString *s;
		NSInteger maxId =0;
		
		//字段
		//select id,documentType,documentId,layoutId,layoutType,layoutVisible,viewId,viewType,viewLabel,
		//viewValue,viewDepartment,viewMulti,viewSubmit,viewVisible,viewTime from tblField
		
		char *sql;
		sql = "select  max(id) from tblField";
		sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
		int code = sqlite3_step(stmt);
		if (code == SQLITE_ROW) {
			int n = sqlite3_column_int(stmt, 0);
			maxId = n+1;
			code = sqlite3_step(stmt);
		}
		sqlite3_finalize(stmt);
		//sqlite3_close(database);
		//strViewValue = @"[{\"t\":\"摘要信息\",\"v\":\"zyxx\"},{\"t\":\"正文内容\",\"v\":\"zwnr\"},{\"t\":\"办理情况\",\"v\":\"blqk\"},{\"t\":\"附件\",\"v\":\"fj\"}]";
		//NSLog(@"strViewValue  %@",strViewValue);
		
		NSString *ssql1 = [NSString stringWithFormat:@"insert into tblField(id,documentType,documentId,infoId,"
						   "layoutId,layoutType,layoutVisible,viewId,viewType,viewLabel,viewValue,"
						   "viewDepartment,viewMulti,viewSubmit,viewVisible,viewTime,infoId_1,viewUid,viewReadOnly,viewNodeName,view_onchange) "
						   "values(%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
						   maxId,strRootType,strDocumentId,strInfoId,strLayoutId,strLayoutType,strLayoutVisible,strViewId,
						   strViewType,strViewLabel,strViewValue,strViewDepartment,strViewMulti,strViewSubmit,
						   strViewVisible,nowtime,strInfoId_1,strViewUId,strViewReadOnly,strViewNodeName,strViewOnChange];
		
		
		s = [[NSString alloc] initWithUTF8String:[ssql1 UTF8String]];
		NSLog(@"insert sql: %@",s);
		/*
		 if(insertUpdate==1){
		 NSString *ssql1 = [NSString stringWithFormat:@"update tblprefixsuffix set Prefixorsuffix='%@',Meaning='%@',Originlanguageetymology='%@',Examples='%@',lastModifyDate='%@'",@"",@"",@"",@"",@""];
		 NSString *ssql2 = [NSString stringWithFormat:@" where Prefixorsuffix='%@'" ,@""];
		 NSString *ssql = [ssql1 stringByAppendingString:ssql2];
		 s = [[NSString alloc] initWithUTF8String:[ssql UTF8String]];
		 NSLog(@"update sql: %@",ssql);
		 }*/
		//
		char *msql = (char *) [s UTF8String];
		char *merror = nil;
		//int resultUpdatetblChangeLog = sqlite3_exec(database, msql, 0, 0,&merror);
		result = sqlite3_exec(database, msql, 0, 0,&merror);
		NSLog(@"m = %d",result);
		if (merror) {
			NSLog(@"Failed to update");
			//NSLog(@"%@", [NSString stringWithCString:merror]);
			sqlite3_close(database);
			return -1;
		}
		if(result != SQLITE_OK){
			NSLog(@" sql: %@" ,s);
			NSLog(@"r = %d",result);
			sqlite3_close(database);
			return -1;
		}
		[s release];
	}
	
	sqlite3_close(database);
	return result;
}

//修改报文的状态
//-(NSInteger)alterDocumentState:(NSString *)strDocumentType documentId:(NSString *)strDocumentId id:(NSInteger)i_id state:(NSString *)state{

-(NSInteger)alterDocumentState:(NSString *)strDocumentType documentId:(NSString *)strDocumentId  state:(NSString *)state{
	/*
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *_databaseFullPath = [documentsDirectory stringByAppendingPathComponent:kDatabaseName];
	strDatabasePath = [documentsDirectory stringByAppendingPathComponent:@"gtfund0.sqlite"];
	strDatabasePath0 = [documentsDirectory stringByAppendingPathComponent:@"gtfund1.sqlite"];
	
	NSError *error = nil;
	if (![[NSFileManager defaultManager] AESEncryptFile:databasePath toFile:strDatabasePath usingPassphrase:@"11111111" error:&error])
	{
		NSLog(@"Failed to write encrypted file. Error = %@", [[error userInfo] objectForKey:AESEncryptionErrorDescriptionKey]);
	}
	
	//NSError *error = nil;
	if (![[NSFileManager defaultManager] AESDecryptFile:strDatabasePath toFile:strDatabasePath0 usingPassphrase:@"11111111" error:&error])
	{
		NSLog(@"Failed to write encrypted file. Error = %@", [[error userInfo] objectForKey:AESEncryptionErrorDescriptionKey]);
	}
	//-(BOOL)AESDecryptFile:(NSString *)inPath toFile:(NSString *)outPath usingPassphrase:(NSString *)pass error:(NSError **)error
	*/

	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can't open the database.");
		return -1;
	}
	//NSDate *now = [NSDate date];
	//NSLog(@"%@",[now description]);
	//NSString *nowtime = [now description];
	
	
	NSString *ssql1 = [NSString stringWithFormat:@"update tblDocumentList set documentState='%@'",state];
	NSString *ssql2 = [NSString stringWithFormat:@" where documentId = '%@'" ,strDocumentId];
	
	//NSString *ssql2 = [NSString stringWithFormat:@" where documentType='%@' and documentId = '%@'" ,strDocumentType,strDocumentId];

	//NSString *ssql2 = [NSString stringWithFormat:@" where documentType='%@' and documentId = '%@' and id=%d" ,strDocumentType,strDocumentId,i_id];

	NSString *ssql = [ssql1 stringByAppendingString:ssql2];
	NSString *s = [[NSString alloc] initWithUTF8String:[ssql UTF8String]];
	char *msql = (char *) [s UTF8String];
	char *merror = nil;
	//int resultUpdatetblChangeLog = sqlite3_exec(database, msql, 0, 0,&merror);
	int resultUpdatetblLab = sqlite3_exec(database, msql, 0, 0,&merror);
	
	if(resultUpdatetblLab != SQLITE_OK){
		NSLog(@" sql: %@" ,s);
		NSLog(@"r = %d",resultUpdatetblLab);
		sqlite3_close(database);
		return -1;
	}
	//NSLog(@"update sql: %@",ssql);
	NSLog(@"m = %d",resultUpdatetblLab);
	if (merror) {
		return -1;
	}
	sqlite3_close(database);
	return resultUpdatetblLab;
}


//保存意见
-(NSInteger)saveOpinionValue:(NSString *)infoId opinionValue:(NSString *)opinionValue{
	
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can't open the database.");
		return -1;
	}
	//NSDate *now = [NSDate date];
	//NSLog(@"%@",[now description]);
	//NSString *nowtime = [now description];
	
	//update tblField set viewValue = ' test'  where infoId='150021722-0' and layoutId='zyxx_yj' and viewLabel='审签意见'
	
	 NSString *ssql1 = [NSString stringWithFormat:@"update tblField set viewValue ='%@'",opinionValue];
	 NSString *ssql2 = [NSString stringWithFormat:@" where infoId='%@' and layoutId='zyxx_yj' and viewLabel='审签意见'" ,infoId];
	 NSString *ssql = [ssql1 stringByAppendingString:ssql2];
	 NSString *s = [[NSString alloc] initWithUTF8String:[ssql UTF8String]];
	 char *msql = (char *) [s UTF8String];
	 char *merror = nil;
	 //int resultUpdatetblChangeLog = sqlite3_exec(database, msql, 0, 0,&merror);
	 int result = sqlite3_exec(database, msql, 0, 0,&merror);
	 if(result != SQLITE_OK){
	 NSLog(@" sql: %@" ,s);
	 NSLog(@"r = %d",result);
	 sqlite3_close(database);
	 return -1;
	 }
	 //NSLog(@"update sql: %@",ssql);
	 NSLog(@"m = %d",result);
	 if (merror) {
		 return -1;
	 }
	 
	sqlite3_close(database);
	return result;
}

//保存处理方式
//-(NSInteger)saveOptionValue:(NSString *)infoId optionValue:(NSString *)optionValue{
-(NSInteger)saveOptionValue:(NSString *)infoId optionValue:(NSMutableArray *)arrayData{
	
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can't open the database.");
		return -1;
	}
	//NSDate *now = [NSDate date];
	//NSLog(@"%@",[now description]);
	//NSString *nowtime = [now description];
	
	//update tblField set viewValue = ' test'  where infoId='150021722-0' and layoutId='zyxx_yj' and viewLabel='审签意见'
	NSString *strValue =@"";
	if ([arrayData count]>0) {
		strValue = [arrayData JSONRepresentation];
	}
	NSString *ssql1 = [NSString stringWithFormat:@"update tblField set view_clfsValue ='%@'",strValue];
	NSString *ssql2 = [NSString stringWithFormat:@" where infoId='%@' and layoutId='zyxx_clfs' and viewId='clfs'" ,infoId];
	NSString *ssql = [ssql1 stringByAppendingString:ssql2];
	NSString *s = [[NSString alloc] initWithUTF8String:[ssql UTF8String]];
	NSLog(@" sql: %@" ,s);
	char *msql = (char *) [s UTF8String];
	char *merror = nil;
	//int resultUpdatetblChangeLog = sqlite3_exec(database, msql, 0, 0,&merror);
	int result = sqlite3_exec(database, msql, 0, 0,&merror);
	if(result != SQLITE_OK){
		NSLog(@" sql: %@" ,s);
		NSLog(@"r = %d",result);
		sqlite3_close(database);
		return -1;
	}
	//NSLog(@"update sql: %@",ssql);
	NSLog(@"m = %d",result);
	if (merror) {
		return -1;
	}
	
	sqlite3_close(database);
	return result;
}





//获到submitList 数据 
-(NSArray *)getSubmitList:(NSString *)strDocumentId{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	// >>>>> 
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can not open the database");
		return [array autorelease];
	}
	sqlite3_stmt *stmt;
	//char *sql = "select id,layoutid,layoutType,viewId,viewType,viewLabel,viewMsg,viewTime from tblField order by viewTime desc";
	//char *sql = "select id,documentType,documentId,layoutId,layoutType,layoutVisible,viewId,viewType,viewLabel,viewValue,viewDepartment,viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zyxx%'";
	NSString *sql =[NSString stringWithFormat:@"select id,viewId,viewValue from tblField where layoutId ='submitList' and infoId='%@'",strDocumentId];
	
	char *msql = (char *) [sql UTF8String];
	sqlite3_prepare_v2(database, msql, -1, &stmt, NULL);
	int  code = sqlite3_step(stmt);
	while (code == SQLITE_ROW) {
		
		NSMutableDictionary *d;
		d = [[NSMutableDictionary alloc] init];
		char *c;
		NSString *s;
		int n = sqlite3_column_int(stmt, 0);
		[d setObject:[NSNumber numberWithInt:n] forKey:@"id"];
		
		//
		c  = (char *)sqlite3_column_text(stmt, 1);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewId];
		//
		c  = (char *)sqlite3_column_text(stmt, 2);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewValue];
		
		[array addObject:d];
		[d release];
		//
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	sqlite3_close(database);
	return [array autorelease];
}



//得到摘要信息中的内容
//-(NSArray *)getAbstractFieldList:(NSString *)strDocumentId layoutId:(NSString *)layoutId{
-(NSArray *)getAbstractFieldList:(NSString *)strDocumentId{

	NSMutableArray *array = [[NSMutableArray alloc] init];
	// >>>>> 
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can not open the database");
		return [array autorelease];
	}
	sqlite3_stmt *stmt;
	//char *sql = "select id,layoutid,layoutType,viewId,viewType,viewLabel,viewMsg,viewTime from tblField order by viewTime desc";
	//char *sql = "select id,documentType,documentId,layoutId,layoutType,layoutVisible,viewId,viewType,viewLabel,viewValue,viewDepartment,viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zyxx%'";
	NSString *sql =[NSString stringWithFormat:@"select id,documentType,documentId,layoutId,viewId,viewType,viewLabel,viewValue,viewDepartment,"
					"viewMulti,viewSubmit,viewVisible,viewTime,infoId,viewReadOnly,viewNodeName,view_clfsValue,view_onchange from tblField where layoutId like '%%zyxx%%' and infoId='%@'",strDocumentId];
	
	char *msql = (char *) [sql UTF8String];
	sqlite3_prepare_v2(database, msql, -1, &stmt, NULL);
	int  code = sqlite3_step(stmt);
	while (code == SQLITE_ROW) {
		
		NSMutableDictionary *d;
		d = [[NSMutableDictionary alloc] init];
		char *c;
		NSString *s;
		int n = sqlite3_column_int(stmt, 0);
		[d setObject:[NSNumber numberWithInt:n] forKey:@"id"];
		//
		c  = (char *)sqlite3_column_text(stmt, 1);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewLabel %@",s);
		[d setObject:s forKey:kDocumentType];
		//
		c  = (char *)sqlite3_column_text(stmt, 2);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewTime %@",s);
		[d setObject:s forKey:kDocumentId];
		//
		c  = (char *)sqlite3_column_text(stmt, 3);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_layoutId];
		//
		c  = (char *)sqlite3_column_text(stmt, 4);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewId];
		//
		c  = (char *)sqlite3_column_text(stmt, 5);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewType];
		
		
		c  = (char *)sqlite3_column_text(stmt, 6);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewLabel];
		//
		c  = (char *)sqlite3_column_text(stmt, 7);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewValue];
		//
		c  = (char *)sqlite3_column_text(stmt, 8);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewDepartment];
		//
		c  = (char *)sqlite3_column_text(stmt, 9);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewMulti];
		//
		c  = (char *)sqlite3_column_text(stmt, 10);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewSubmit];
		//
		c  = (char *)sqlite3_column_text(stmt, 11);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewVisible];
		//
		c  = (char *)sqlite3_column_text(stmt, 12);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewTime];
		//
		c = (char *)sqlite3_column_text(stmt, 13);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kInfoId];
		//[s release];
		c = (char *)sqlite3_column_text(stmt, 14);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewReadonly];
		//
		c = (char *)sqlite3_column_text(stmt, 15);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewNodeName];
		
		c = (char *)sqlite3_column_text(stmt, 16);
		//NSLog(@"%c",c);
		if (c) {
			s = [NSString stringWithUTF8String:c];
			
			[d setObject:s forKey:kName_viewClfsValue];
		}else {
			//s = [NSString stringWithUTF8String:c];
			[d setObject:@"" forKey:kName_viewClfsValue];
		}

		//onchange
		c = (char *)sqlite3_column_text(stmt, 17);
		//NSLog(@"%c",c);
		if (c) {
			s = [NSString stringWithUTF8String:c];
			
			[d setObject:s forKey:kName_ViewOnchange];
		}else {
			//s = [NSString stringWithUTF8String:c];
			[d setObject:@"" forKey:kName_ViewOnchange];
		}
		
		
		//
		[array addObject:d];
		[d release];
		//
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	sqlite3_close(database);
	return [array autorelease];
}

//得到摘要信息中的内容
-(NSArray *)getMainBodyData:(NSString *)strDocumentId{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	// >>>>> 
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can not open the database");
		return [array autorelease];
	}
	sqlite3_stmt *stmt;
	
	NSString *ssql1 =[NSString stringWithFormat:@"select id,documentType,documentId,layoutId,viewId,viewType,viewLabel,viewValue,viewDepartment,"
					  "viewMulti,viewSubmit,viewVisible,viewTime,infoId from tblField where layoutId like '%%zwnr%%' and infoId='%@'",strDocumentId ];
	
	NSString *s = [[NSString alloc] initWithUTF8String:[ssql1 UTF8String]];
	//NSLog(@"selectπ sql: %@",s);
	char *sql = (char *) [s UTF8String];
	
	//char *sql = "select id,layoutid,layoutType,viewId,viewType,viewLabel,viewMsg,viewTime from tblField order by viewTime desc";
	//char *sql = "select id,documentType,documentId,layoutId,layoutType,layoutVisible,viewId,viewType,viewLabel,viewValue,viewDepartment,viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zyxx%'";
	
	//char *sql = "select id,documentType,documentId,layoutId,viewId,viewType,viewLabel,viewValue,viewDepartment,"
	//"viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zwnr%'";
	
	sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
	int  code = sqlite3_step(stmt);
	while (code == SQLITE_ROW) {
		
		NSMutableDictionary *d;
		d = [[NSMutableDictionary alloc] init];
		char *c;
		NSString *s;
		int n = sqlite3_column_int(stmt, 0);
		[d setObject:[NSNumber numberWithInt:n] forKey:@"id"];
		
		//
		//
		c  = (char *)sqlite3_column_text(stmt, 1);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewLabel %@",s);
		[d setObject:s forKey:kDocumentType];
		//
		c  = (char *)sqlite3_column_text(stmt, 2);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewTime %@",s);
		[d setObject:s forKey:kDocumentId];
		//
		c  = (char *)sqlite3_column_text(stmt, 3);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_layoutId];
		//
		c  = (char *)sqlite3_column_text(stmt, 4);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewId];
		//
		c  = (char *)sqlite3_column_text(stmt, 5);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewType];
		
		
		c  = (char *)sqlite3_column_text(stmt, 6);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewLabel];
		//
		c  = (char *)sqlite3_column_text(stmt, 7);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewValue];
		//
		c  = (char *)sqlite3_column_text(stmt, 8);
		s = [[NSString alloc] initWithUTF8String:c];
		[d setObject:s forKey:kName_viewDepartment];
		//
		c  = (char *)sqlite3_column_text(stmt, 9);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewMulti];
		//
		c  = (char *)sqlite3_column_text(stmt, 10);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewSubmit];
		//
		c  = (char *)sqlite3_column_text(stmt, 11);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewVisible];
		//
		c  = (char *)sqlite3_column_text(stmt, 12);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewTime];
		//
		c = (char *)sqlite3_column_text(stmt, 13);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kInfoId];
		//[s release];
		//
		[array addObject:d];
		[d release];
		//
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	sqlite3_close(database);
	return [array autorelease];
}

//获得意见部分的内
-(NSArray *)getOpinionData:(NSString *)strDocumentId{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	// >>>>> 
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can not open the database");
		return [array autorelease];
	}
	sqlite3_stmt *stmt;
	
	NSString *ssql1 = [NSString stringWithFormat: @"select id,documentType,documentId,layoutId,viewId,viewType,viewLabel,viewValue,viewDepartment,"
					   "viewMulti,viewSubmit,viewVisible,viewTime,infoId,viewUid from tblField where layoutId like '%%blqk%%' and infoId='%@' order by layoutid,id",strDocumentId];
	
	NSString *s = [[NSString alloc] initWithUTF8String:[ssql1 UTF8String]];
	//NSLog(@"selectπ sql: %@",s);
	char *sql = (char *) [s UTF8String];
	
	//char *sql = "select id,layoutid,layoutType,viewId,viewType,viewLabel,viewMsg,viewTime from tblField order by viewTime desc";
	//char *sql = "select id,documentType,documentId,layoutId,layoutType,layoutVisible,viewId,viewType,viewLabel,viewValue,viewDepartment,viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zyxx%'";
	
	//char *sql = "select id,documentType,documentId,layoutId,viewId,viewType,viewLabel,viewValue,viewDepartment,"
	//"viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zwnr%'";
	
	sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
	int  code = sqlite3_step(stmt);
	while (code == SQLITE_ROW) {
		
		NSMutableDictionary *d;
		d = [[NSMutableDictionary alloc] init];
		char *c;
		NSString *s;
		int n = sqlite3_column_int(stmt, 0);
		[d setObject:[NSNumber numberWithInt:n] forKey:@"id"];
		//
		c  = (char *)sqlite3_column_text(stmt, 1);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewLabel %@",s);
		[d setObject:s forKey:kDocumentType];
		//
		c  = (char *)sqlite3_column_text(stmt, 2);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewTime %@",s);
		[d setObject:s forKey:kDocumentId];
		//
		c  = (char *)sqlite3_column_text(stmt, 3);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_layoutId];
		//
		c  = (char *)sqlite3_column_text(stmt, 4);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewId];
		//
		c  = (char *)sqlite3_column_text(stmt, 5);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewType];
		
		
		c  = (char *)sqlite3_column_text(stmt, 6);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewLabel];
		//
		c  = (char *)sqlite3_column_text(stmt, 7);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewValue];
		//
		c  = (char *)sqlite3_column_text(stmt, 8);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewDepartment];
		//
		c  = (char *)sqlite3_column_text(stmt, 9);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewMulti];
		//
		c  = (char *)sqlite3_column_text(stmt, 10);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewSubmit];
		//
		c  = (char *)sqlite3_column_text(stmt, 11);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewVisible];
		//
		c  = (char *)sqlite3_column_text(stmt, 12);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewTime];
		//
		c = (char *)sqlite3_column_text(stmt, 13);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kInfoId];
		//
		c = (char *)sqlite3_column_text(stmt, 14);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewUid];
		//[s release];
		//
		[array addObject:d];
		[d release];
		//
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	sqlite3_close(database);
	return [array autorelease];
	
}


//办理情况
-(NSArray *)getOpinionDataList:(NSString *)strDocumentId layoutId:(NSString *)layoutId{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	// >>>>> 
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can not open the database");
		return [array autorelease];
	}
	sqlite3_stmt *stmt;
	
	NSString *ssql1 = [NSString stringWithFormat: @"select id,documentType,documentId,layoutId,viewId,viewType,viewLabel,viewValue,viewDepartment,"
					   "viewMulti,viewSubmit,viewVisible,viewTime,infoId from tblField where layoutId like '%%blqk%%' and infoId='%@' and layoutId='%@' order by layoutid,id",strDocumentId,layoutId];
	
	NSString *s = [[NSString alloc] initWithUTF8String:[ssql1 UTF8String]];
	//NSLog(@"selectπ sql: %@",s);
	char *sql = (char *) [s UTF8String];
	
	//char *sql = "select id,layoutid,layoutType,viewId,viewType,viewLabel,viewMsg,viewTime from tblField order by viewTime desc";
	//char *sql = "select id,documentType,documentId,layoutId,layoutType,layoutVisible,viewId,viewType,viewLabel,viewValue,viewDepartment,viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zyxx%'";
	
	//char *sql = "select id,documentType,documentId,layoutId,viewId,viewType,viewLabel,viewValue,viewDepartment,"
	//"viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zwnr%'";
	
	sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
	int  code = sqlite3_step(stmt);
	while (code == SQLITE_ROW) {
		
		NSMutableDictionary *d;
		d = [[NSMutableDictionary alloc] init];
		char *c;
		NSString *s;
		int n = sqlite3_column_int(stmt, 0);
		[d setObject:[NSNumber numberWithInt:n] forKey:@"id"];
		
		//
		//
		c  = (char *)sqlite3_column_text(stmt, 1);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewLabel %@",s);
		[d setObject:s forKey:kDocumentType];
		//
		c  = (char *)sqlite3_column_text(stmt, 2);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewTime %@",s);
		[d setObject:s forKey:kDocumentId];
		//
		c  = (char *)sqlite3_column_text(stmt, 3);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_layoutId];
		//
		c  = (char *)sqlite3_column_text(stmt, 4);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewId];
		//
		c  = (char *)sqlite3_column_text(stmt, 5);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewType];
		
		
		c  = (char *)sqlite3_column_text(stmt, 6);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewLabel];
		//
		c  = (char *)sqlite3_column_text(stmt, 7);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewValue];
		//
		c  = (char *)sqlite3_column_text(stmt, 8);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewDepartment];
		//
		c  = (char *)sqlite3_column_text(stmt, 9);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewMulti];
		//
		c  = (char *)sqlite3_column_text(stmt, 10);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewSubmit];
		//
		c  = (char *)sqlite3_column_text(stmt, 11);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewVisible];
		//
		c  = (char *)sqlite3_column_text(stmt, 12);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewTime];
		//
		c = (char *)sqlite3_column_text(stmt, 13);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kInfoId];
		//[s release];
		//
		[array addObject:d];
		[d release];
		//
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	sqlite3_close(database);
	return [array autorelease];
	
}



//获得附件的内容
-(NSArray *)getAttachmentData:(NSString *)strDocumentId{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	// >>>>> 
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can not open the database");
		return [array autorelease];
	}
	sqlite3_stmt *stmt;
	
	NSString *ssql1 = [NSString stringWithFormat: @"select id,documentType,documentId,layoutId,viewId,viewType,viewLabel,viewValue,viewDepartment,"
					   "viewMulti,viewSubmit,viewVisible,viewTime,infoId,infoId_1,view_onchange from tblField where layoutId like '%%fj%%' and infoId='%@' order by id",strDocumentId];
	
	NSString *s = [[NSString alloc] initWithUTF8String:[ssql1 UTF8String]];
	NSLog(@"select sql: %@",s);
	char *sql = (char *) [s UTF8String];
	
	//char *sql = "select id,layoutid,layoutType,viewId,viewType,viewLabel,viewMsg,viewTime from tblField order by viewTime desc";
	//char *sql = "select id,documentType,documentId,layoutId,layoutType,layoutVisible,viewId,viewType,viewLabel,viewValue,viewDepartment,viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zyxx%'";
	
	//char *sql = "select id,documentType,documentId,layoutId,viewId,viewType,viewLabel,viewValue,viewDepartment,"
	//"viewMulti,viewSubmit,viewVisible,viewTime from tblField where layoutId like '%zwnr%'";
	
	sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
	int  code = sqlite3_step(stmt);
	while (code == SQLITE_ROW) {
		
		NSMutableDictionary *d;
		d = [[NSMutableDictionary alloc] init];
		char *c;
		NSString *s;
		int n = sqlite3_column_int(stmt, 0);
		[d setObject:[NSNumber numberWithInt:n] forKey:@"id"];
		
		//
		c  = (char *)sqlite3_column_text(stmt, 1);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewLabel %@",s);
		[d setObject:s forKey:kDocumentType];
		//
		c  = (char *)sqlite3_column_text(stmt, 2);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewTime %@",s);
		[d setObject:s forKey:kDocumentId];
		//
		c  = (char *)sqlite3_column_text(stmt, 3);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_layoutId];
		//
		c  = (char *)sqlite3_column_text(stmt, 4);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewId];
		//
		c  = (char *)sqlite3_column_text(stmt, 5);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewType];
		
		
		c  = (char *)sqlite3_column_text(stmt, 6);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewLabel];
		//
		c  = (char *)sqlite3_column_text(stmt, 7);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewValue];
		//
		c  = (char *)sqlite3_column_text(stmt, 8);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewDepartment];
		//
		c  = (char *)sqlite3_column_text(stmt, 9);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewMulti];
		//
		c  = (char *)sqlite3_column_text(stmt, 10);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewSubmit];
		//
		c  = (char *)sqlite3_column_text(stmt, 11);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewVisible];
		//
		c  = (char *)sqlite3_column_text(stmt, 12);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_viewTime];
		//
		c = (char *)sqlite3_column_text(stmt, 13);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kInfoId];
		//
		c = (char *)sqlite3_column_text(stmt, 14);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kInfoId_1];
		//[s release];
		
		
		c = (char *)sqlite3_column_text(stmt, 15);
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:kName_ViewOnchange];
		
		//
		[array addObject:d];
		[d release];
		//
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	sqlite3_close(database);
	return [array autorelease];
	
}



-(NSString *)md5:(NSString *)str {
	
	const char *cStr = [str UTF8String];
	
	unsigned char result[16];
	
	CC_MD5( cStr, strlen(cStr), result );
	
	return [NSString stringWithFormat:
			
			@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
			
			result[0], result[1], result[2], result[3], 
			
			result[4], result[5], result[6], result[7],
			
			result[8], result[9], result[10], result[11],
			
			result[12], result[13], result[14], result[15]
			
			]; 
	
}


//
- (NSString *)md5Digest:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
   
	CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11], result[12], result[13], result[14], result[15]
            ];
}


//获取 iPhone 上联系人姓名、电话、邮件的代码  ios4
- (NSMutableArray *) getAllContacts
{
    NSMutableArray *contactsArray = [[[NSMutableArray alloc] init] autorelease];
	/*
	NSMutableArray* personArray = [[[NSMutableArray alloc] init] autorelease];
    
	
    ABAddressBookRef addressBook = ABAddressBookCreate();
   // NSString *firstName, *lastName, *fullName;
   // personArray = (NSMutableArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    /*
   // Contacts *contact;
    for (id *person in personArray)
    {
        //contact = [[Contacts alloc] init];    
        firstName = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        firstName = [firstName stringByAppendingFormat:@" "];
        lastName = (NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);    
        fullName = [firstName stringByAppendingFormat:@"%@",lastName];
        //contact.contactName = fullName;
        
        ABMultiValueRef phones = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonPhoneProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(phones); i++)
        {  
            NSString *phone = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            //[contact.contactPhoneArray addObject:phone];
        }
        
        ABMultiValueRef mails = (ABMultiValueRef) ABRecordCopyValue(person, kABPersonEmailProperty);
        for(int i = 0 ;i < ABMultiValueGetCount(mails); i++)
        {  
            NSString *mail = (NSString *)ABMultiValueCopyValueAtIndex(mails, i);
            //[contact.contactMailArray addObject:mail];
        }        
        //[contactsArray addObject:contact];   // add contact into array
       //[contact release];
    }  */  
    return contactsArray;
}

//====
- (NSDate *)createDateWith:(int *)year :(int *)month :(int *)day 
{
	
	NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
	[dateComponents setYear:*year];
	[dateComponents setMonth:*month];
	[dateComponents setDay:*day];
	NSDate *_nsDate = [[[NSCalendar currentCalendar] dateFromComponents:dateComponents] retain];
	[dateComponents release];
	
	return _nsDate;
}

/*
 //
 - (BOOL) connectedToNetwork
 
 {
 // Create zero addy
 
 struct sockaddr_in zeroAddress;
 
 bzero(&zeroAddress, sizeof(zeroAddress));
 
 zeroAddress.sin_len = sizeof(zeroAddress);
 
 zeroAddress.sin_family = AF_INET;
 
 // Recover reachability flags
 
 SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
 
 SCNetworkReachabilityFlags flags;
 
 BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
 
 CFRelease(defaultRouteReachability);
 
 if (!didRetrieveFlags)
 
 {
 
 NSLog(@"Error. Could not recover network reachability flags");
 
 return NO;
 
 }
 
 BOOL isReachable = flags & kSCNetworkFlagsReachable;
 
 BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
 
 BOOL nonWiFi = flags & kSCNetworkReachabilityFlagsTransientConnection;
 
 //向苹果网站发送请求，严正URL链接是否成功 
 
 NSURL *testURL = [NSURL URLWithString:@"http://www.apple.com/"];
 
 NSURLRequest *testRequest = [NSURLRequest requestWithURL:testURL  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0];
 
 NSURLConnection *testConnection = [[NSURLConnection alloc] initWithRequest:testRequest delegate:self];
 
 return ((isReachable && !needsConnection) || nonWiFi) ? (testConnection ? YES : NO) : NO;
 }
 */

//
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
								 float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}


- (UIImage *) createRoundedRectImage:(UIImage*)image size:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 10, 10);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return [UIImage imageWithCGImage:imageMasked];
}


/*
 //设置nav bar 的背景图片
 //input: The image and a tag to later identify the view  
 @implementation UINavigationBar (CustomImage)  
 - (void)drawRect:(CGRect)rect {  
 UIImage *image = [UIImage imageNamed: @"icon320.png"];  
 [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];  
 }  
 @end 
 */


/*
#import <Message/NetWorkController.h>

if ( ([[NetworkController sharedInstance]isFatPipe]) )
{
	//这就是wifi无线网络状态
}

if ( ([[NetworkController sharedInstance]isEdgeUp]) ) //这是edge网络状态
//当以上两种状态至少一种可用时
if ( ([[NetworkController sharedInstance]isNetworkUp]) )   都返回YES;
 */

- (NSInteger)insertShop:(NSMutableArray *)shopArray{
	
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can't open the database.");
		return -1;
	}
	//
	if([shopArray count] <= 0){
		NSLog(@"shopArray is empty.");
		return -1;
	}
	
	//NSInteger t = sqlite3_key(database,"1q2w3e4r",8);
	int insertResult;
	for (int i=0; i<[shopArray count]; i++) {
		//ShopInfo * shop = [[ShopInfo alloc] init];
		ShopInfo * shop = [shopArray objectAtIndex:i];
		//
		sqlite3_stmt *stmt;
		/*
		NSString *strSelect = [NSString stringWithFormat:@"select key from shop where key = '%@'",strId];
		//NSLog(@"delete sql :%@",strDelete);
		char *ssql = (char *) [strSelect UTF8String];
		//char *_merror = nil;
		sqlite3_prepare_v2(database, ssql, -1, &stmt, NULL);
		int result = sqlite3_step(stmt);
		if(result == SQLITE_ROW){
			char *c;
			c  = (char *)sqlite3_column_text(stmt, 0);
			NSString *s = [NSString stringWithUTF8String:c];
			if ([s isEqualToString:strId]) {
				sqlite3_finalize(stmt);
				sqlite3_close(database);
				return SQLITE_ExistRow;//
			}
		}*/
		
		NSDate *now = [NSDate date];
		NSString *nowtime = [now description];
		//NSLog(@"root nowtime %@",nowtime);
		NSString *s;
		
		NSInteger maxId =0;
		//sqlite3_stmt *stmt;
		char *sql;
		sql = "select max(key) from shop";
		sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
		int code = sqlite3_step(stmt);
		if (code == SQLITE_ROW) {
			int n = sqlite3_column_int(stmt, 0);
			maxId = n+1;
			code = sqlite3_step(stmt);
		}
		sqlite3_finalize(stmt);
		
		NSString *ssql1 = [NSString stringWithFormat:
						   @"insert into tblShop(key,name,imagename,address,altitude,longitude,description,telephone,"
						   "discountInfo,cardType,time) values(%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",
						   maxId,shop.name,shop.imagename,shop.address,shop.altitude,shop.longitude,shop.description,shop.telephone,shop.discountInfo,shop.cardType,nowtime];
		
		s = [[NSString alloc] initWithUTF8String:[ssql1 UTF8String]];
		NSLog(@"insert sql: %@",s);
		
		char *msql = (char *) [s UTF8String];
		char *merror = nil;
		//int resultUpdatetblChangeLog = sqlite3_exec(database, msql, 0, 0,&merror);
		insertResult = sqlite3_exec(database, msql, 0, 0,&merror);
		if (merror) {
			NSLog(@"Failed to update");
			//NSLog(@"%@", [NSString stringWithCString:merror]);
			NSLog(@"result = %d",insertResult);
			sqlite3_close(database);
			[s release];
			return -1;
		}else {
			if(insertResult != SQLITE_OK){
				NSLog(@" sql: %@" ,s);
				NSLog(@"result = %d",insertResult);
				sqlite3_close(database);
				[s release];
				return -1;
			}
			
		}
		[s release];
		NSLog(@"m = %d",insertResult);
	}
	//
	sqlite3_close(database);
	return insertResult;
}


//获得附件的内容
-(NSMutableArray *)getShopsData{
	NSMutableArray *array = [[NSMutableArray alloc] init];
	// >>>>> 
	int n = sqlite3_open([databasePath UTF8String], &database);
	if(n != SQLITE_OK){
		NSLog(@"can not open the database");
		return [array autorelease];
	}
	sqlite3_stmt *stmt;
	
	NSString *ssql1 = [NSString stringWithFormat: @"select key,name,imagename,address,altitude,longitude,"
					   "description,telephone,discountInfo,cardType,time  from tblShop  order by key "];
	
	NSString *s = [[NSString alloc] initWithUTF8String:[ssql1 UTF8String]];
	NSLog(@"select sql: %@",s);
	char *sql = (char *) [s UTF8String];
	
	sqlite3_prepare_v2(database, sql, -1, &stmt, NULL);
	int  code = sqlite3_step(stmt);
	while (code == SQLITE_ROW) {
		
		NSMutableDictionary *d;
		d = [[NSMutableDictionary alloc] init];
		char *c;
		NSString *s;
		int n = sqlite3_column_int(stmt, 0);
		[d setObject:[NSNumber numberWithInt:n] forKey:@"key"];
		
		//
		c  = (char *)sqlite3_column_text(stmt, 1);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewLabel %@",s);
		[d setObject:s forKey:@"name"];
		//
		c  = (char *)sqlite3_column_text(stmt, 2);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		//NSLog(@"viewTime %@",s);
		[d setObject:s forKey:@"imagename"];
		//
		c  = (char *)sqlite3_column_text(stmt, 3);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"address"];
		//
		c  = (char *)sqlite3_column_text(stmt, 4);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"altitude"];
		//
		c  = (char *)sqlite3_column_text(stmt, 5);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"longitude"];
		
		
		c  = (char *)sqlite3_column_text(stmt, 6);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"description"];
		//
		c  = (char *)sqlite3_column_text(stmt, 7);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"telephone"];
		//
		c  = (char *)sqlite3_column_text(stmt, 8);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"discountInfo"];
		//
		c  = (char *)sqlite3_column_text(stmt, 9);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"cardType"];
		//
		c  = (char *)sqlite3_column_text(stmt, 10);
		//s = [[NSString alloc] initWithUTF8String:c];
		s = [NSString stringWithUTF8String:c];
		[d setObject:s forKey:@"time"];
		
		//
		[array addObject:d];
		[d release];
		code = sqlite3_step(stmt);
	}
	sqlite3_finalize(stmt);
	sqlite3_close(database);
	return [array autorelease];
}



@end
