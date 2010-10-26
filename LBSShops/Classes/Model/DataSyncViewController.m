//
//  DataSyncViewController.m
//  Jepoque
//
//  Created by Tsang Mars on 9/28/09.
//  Copyright 2009 jepoque. All rights reserved.
//

#import "DataSyncViewController.h"
#import "DataManager.h"
#import "JSON.h"
#import "GTMBase64.h"
#import "predfin.h"
#import "Reachability.h"
#import "LFCGzipUtility.h"



@implementation DataSyncViewController

@synthesize aiView;
@synthesize loadingLabel;
@synthesize timer;
//@synthesize documentParser;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	//
	/*
	UIImage *backImgage = [UIImage imageNamed:@"back_MainStar.png"];
	[(UIImageView *)self.view setImage:backImgage];
	
	[aiView setAlpha:1];
	[loadingLabel setAlpha:1];
	[aiView startAnimating];
	*/
	opQueue = [[NSOperationQueue alloc] init];
	//[opQueue setMaxConcurrentOperationCount:2];
	isSameTimeDesc = YES;

	isMore = -1;
	
	//NSBundle *mainBundle = [NSBundle mainBundle];
	//soundChicken = [[SoundEffect alloc] initWithContentsOfFile:[mainBundle pathForResource:@"Done" ofType:@"aiff"]];	

	//新报文声音效果
	//[soundChicken play];
}


//
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
	//NSLog(@"viewWillAppear");
	//
	/*
	UIImage *backImgage = [UIImage imageNamed:@"backgroundlogo.png"];
	[(UIImageView *)self.view setImage:backImgage];
	/*
	 UIImage *image = [UIImage imageNamed:@"LogoAnimation_09.png"];
	 [(UIImageView *)self.view setImage:image];
	 NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
	 for(int i=1;i<=9;i++){
	 NSString *imageName = [NSString stringWithFormat:@"LogoAnimation_0%d.png",i];
	 //NSLog(@"imageName: %@",imageName);
	 UIImage *animationImage = [UIImage imageNamed:imageName];
	 [imagesArray  addObject:animationImage];
	 }
	 //
	 UIImageView *animationImageView = (UIImageView *)self.view;
	 animationImageView.animationImages = imagesArray;
	 animationImageView.animationDuration = [imagesArray count]*kLogoAnimateInterval;
	 //重复动画次数
	 animationImageView.animationRepeatCount = 1;
	 //开始动画
	 [animationImageView startAnimating];
	 
	 [aiView setAlpha:0];
	 [loadingLabel setAlpha:0];
	 [imagesArray release];
	 //
	 */
	
	//[self beginDataSyncWork];
	
	/*
	[aiView setAlpha:1];
	[loadingLabel setAlpha:1];
	[aiView startAnimating];
	[self performSelectorOnMainThread:@selector(beginDataSyncWork) withObject:nil waitUntilDone:YES];
	
	timer=[NSTimer scheduledTimerWithTimeInterval:6.0*10 target:self selector:@selector(updateDocument) userInfo:nil repeats:YES];
		*/
}
//
- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:YES];
	//
	UIImage *backImgage = [UIImage imageNamed:@"back_MainStar.png"];
	[(UIImageView *)self.view setImage:backImgage];
	
	/*
	UIImage *image = [UIImage imageNamed:@"LogoAnimation_09.png"];
	[(UIImageView *)self.view setImage:image];
	NSMutableArray *imagesArray = [[NSMutableArray alloc] init];
	for(int i=1;i<=9;i++){
		NSString *imageName = [NSString stringWithFormat:@"LogoAnimation_0%d.png",i];
		//NSLog(@"imageName: %@",imageName);
		UIImage *animationImage = [UIImage imageNamed:imageName];
		[imagesArray  addObject:animationImage];
	}
	//
	UIImageView *animationImageView = (UIImageView *)self.view;
	animationImageView.animationImages = imagesArray;
	animationImageView.animationDuration = [imagesArray count]*kLogoAnimateInterval;
	//重复动画次数
	animationImageView.animationRepeatCount = 1;
	//开始动画
	[animationImageView startAnimating];
	  
	[aiView setAlpha:0];
	[loadingLabel setAlpha:0];
	[imagesArray release];
	//
	 */
	
	/*
	UIFont *f = [UIFont italicSystemFontOfSize:15];
	TTSearchlightLabel *label = [[[TTSearchlightLabel alloc] initWithFrame:CGRectMake(20, 400, 260, 30)] autorelease];
	label.text = @"Copyright 2010 GtFund Inc.";
	//label.backgroundColor = [UIColor clearColor];
	label.font = f;
	label.textColor = [UIColor whiteColor];
	label.spotlightColor = [UIColor blueColor];
	label.textAlignment = UITextAlignmentCenter;
	label.contentMode = UIViewContentModeCenter;
	[self.view addSubview:label];
	[label startAnimating];
	*/
	
	[aiView setAlpha:1];
	[loadingLabel setAlpha:1];
	[aiView startAnimating];
	
	//[self doDataSyncTask];
	
	[self performSelectorOnMainThread:@selector(beginDataSyncWork) withObject:nil waitUntilDone:YES];
		
	//定时向服务器取数据
	timer=[NSTimer scheduledTimerWithTimeInterval:6.0*10*2 target:self selector:@selector(updateDocument) userInfo:nil repeats:YES];
	
	//checkTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkAnimationIsDone) userInfo:nil repeats:YES];
	//return;
}

//每隔一定的时间向服务器去数据
-(void)updateDocument{

	NSLog(@"run");
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[self getDocumentData];

	/*
	//Iphone 客户端提交数据为json格式
	NSString *strUrl = [NSString stringWithFormat:@"%@",kServerUrl];
	NSURL *url = [NSURL URLWithString:strUrl];
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	NSString *httpBodyString = nil;
	NSMutableArray *arraySendData = [[NSMutableArray alloc] init];
	httpBodyString = [arraySendData JSONRepresentation];
	[arraySendData release];
	//NSLog(@"send update httpBodyString: %@",httpBodyString);
	NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
	[request setHTTPBody:postData]; 
	[request setHTTPMethod:@"POST"];
	//
	NSURLResponse *reponse;
	NSError *error = nil;
	NSString *responseString = nil;
	//
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
	NSMutableArray *getArrayData;
	if (error) {
		NSLog(@"Something wrong: %@",[error description]);
		return;
	}else {
		if (responseData) {
			responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
			//NSLog(@"get update responseString: %@",responseString);
		}
	}
	//
	if(responseString == nil) {
		return;	
	}
	else{
		getArrayData  = [responseString JSONValue];
	}*/
}


//向服务器去取数据
-(void)getDocumentData{
	//NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];
	//
	/*
	NSURL *url = [NSURL URLWithString:@"http://www.jarodyv.com/rss.xml"]; 
	NSMutableURLRequest* urlReq = [[NSMutableURLRequest alloc] initWithURL:url]; 
	//add gzip-encoding to HTTP header 
	[urlReq setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"]; 
	NSData *data0 = [[NSData alloc] initWithContentsOfURL:url];
	
	NSString *str = [[NSString alloc] initWithContentsOfURL:url];
	NSString *_str = [[NSString alloc] initWithData:data0 encoding:NSUTF8StringEncoding];
	*/
	
	NSMutableArray *arrarList = [[NSMutableArray alloc] init];
	[arrarList addObject:@"qb.result"];
	//[arrarList addObject:@"log"];
	/*
	//[arrarList addObject:@"qb.result"];
	[arrarList addObject:@"fw.result"];
	[arrarList addObject:@"ht.result"];
	[arrarList addObject:@"hyjy.result"];
	[arrarList addObject:@"sw.result"];
	[arrarList addObject:@"hk.result"];
	*/
	/*
	for (int i=0; i<[arrarList count]; i++) {
		NSString *path = [[NSBundle mainBundle] pathForResource:[arrarList objectAtIndex:i] ofType:@"xml"];
		//SMS20100626.xml
		
		//获取文件路径
		NSString *string=[[NSString  alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];//获取文件
		//NSLog(@"string value %@",string);
		[string release];
		//==========
		//NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
		//NSData *data = [file readDataToEndOfFile];//得到xml文件
		//[file closeFile];
		
		NSData *data = [[NSData alloc] initWithContentsOfFile:path];
		//[[DocumentParser sharedManager] rootAttribute:data];
		[data release];
		
		NSData *_data = [[NSData alloc] initWithContentsOfFile:path];
		
		[[DocumentParser sharedManager] startParser:_data docId:@"" type:@""];
		[_data release];
		
		//新报文声音效果
		[soundChicken play];
	}*/
	[arrarList release];

	
	//http://IP地址:端口/gtfund/servlet/login.do
	//http://IP地址:端口/gtfund/servlet/document/iphone/comfirm.do  
	//http://192.168.0.219:8080/tbaxis/servlet/document/iphone/confirm.do
	//182.180.50.251
	//http://192.168.0.219:8080/tbaxis/servlet/document/iphone/update.do
	NSString *strURL = [[NSString alloc] initWithFormat:@"%@",kUpdateUrl];
	//strURL = [[NSString alloc] initWithFormat:@"%@",@"http://192.168.0.219:8080/tbaxis/servlet/document/iphone/confirm.do"];
	
	NSLog(@"%@",strURL);
	NSURL *url = [[NSURL alloc] initWithString:strURL];
	[strURL release];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	//NSString *httpBodyString = nil;
	NSMutableArray *arraySendData = [[NSMutableArray alloc] init];
	
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
	
	NSString *strUniquer =  [UIDevice currentDevice].uniqueIdentifier;
	NSLog(@"UUID %@ ",strUniquer);

	//a6032385a8ba2eed1277f3c3f283e7ee6a91c555
	//69B2704C-4CDB-5E73-82DB-1B30D343FA8E 
    [headers setValue:strUniquer forKey:@"Techown-Request-Name"];
	//[headers setValue:@"a6032385a8ba2eed1277f3c3f283e7ee6a91c555" forKey:@"Techown-Request-Name"];
	
    //[headers setValue:[NSString stringWithFormat:@"%d",dataLength] forKey:@"Content-Length"];
    [headers setValue:@"iphone" forKey:@"Techown-Request-Type"];
	
	[request setAllHTTPHeaderFields:headers];
	[request setTimeoutInterval:kSetTimeoutInterval];
	[arraySendData release];
	
	//NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
	//[request setHTTPBody:postData]; 
	[request setHTTPMethod:@"POST"];
	//
	NSURLResponse *reponse;
	NSError *error = nil;
	NSString *responseString = nil;
	//
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
	//hNSString *strRecive = @"{\"more\":\"false\",\"documentGroup\":[{\"data\":\"documentData\",\"docId\":\"001\",\"type\":\"0\"}]}";
	//responseData = [strRecive dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
	
	if (error) {
		NSLog(@"Something wrong: %@",[error description]);
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

		//return;
	}else {
		if (responseData) {
			NSData *_data = [LFCGzipUtility uncompressZippedData:responseData];
			responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
			NSLog(@" reciveData %@ ",responseString);
		}
	}
	
	//小于117 bytes 数据压缩不了
	//NSData *ddata = [@"{\"documentComfirm\":[{\"docId\":\"150021722&oa\",\"type\":\"0 99999999999需要建立一套\u201c估值数据管理系统\u201d\"}]}" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	//NSData *data = [LFCGzipUtility gzipData:ddata];
	NSMutableDictionary *getDicData  = [responseString JSONValue];	
	//NSLog(@"getDicData %@",[getDicData description]);
	
	
	if (getDicData) {
		[self saveDocumentData:getDicData];
	}
	//[pool release];
	 
}


//处理从中间件取得的报文数据
-(void)saveDocumentData:(NSMutableDictionary *)_getDicData{
	
	NSMutableArray *docIdArray = [[NSMutableArray alloc] init];
	NSMutableArray *getArrayData = [NSMutableArray array];
	//
	NSString *strIsMore  = [_getDicData objectForKey:@"more"];
	//NSLog(@"strIsMore %@",strIsMore);
	if ([strIsMore isEqualToString:@"true"]) {
		isMore=1;
	}else if ([strIsMore isEqualToString:@"false"]) {
		isMore=0;
	}

	getArrayData = [_getDicData objectForKey:@"documentGroup"];

	if ([getArrayData count]>0) {
		for (int i=0; i<[getArrayData count]; i++) {
			
			NSMutableDictionary *dic = [getArrayData objectAtIndex:i];
			NSString *strDocId = [dic objectForKey:@"docId"];
			NSString *strType = [dic objectForKey:@"type"];
			
			NSMutableDictionary *docIdDic = [[NSMutableDictionary alloc] init];
			[docIdDic setValue:strDocId forKey:@"docId"];
			[docIdDic setValue:strType forKey:@"operateType"];
			[docIdArray addObject:docIdDic];
		}
		//保存docId list data
		if ([docIdArray count] >0) {
			NSLog(@"docIdArray %@",docIdArray);
			NSInteger result = [[DataManager sharedManager] doSaveDocId:docIdArray];
			NSLog(@"save docId list Data: %d",result);
		}
		
		//
		for (int i=0; i<[getArrayData count]; i++) {
			
			NSMutableDictionary *dic = [getArrayData objectAtIndex:i];
			//NSLog(@"dic %@",dic);
			NSString *strXml = [dic objectForKey:@"data"];
			NSLog(@"strXml %@",strXml);
			NSString *strDocId = [dic objectForKey:@"docId"];
			NSString *strType = [@"" stringByAppendingFormat:@"%@", [dic objectForKey:@"type"]];
			
			if ([strType isEqualToString:@"0"]) {
				//新增
				NSData *xmlData = [strXml dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
				if (xmlData && strDocId && strType) {
					//[[DocumentParser sharedManager] startParser:xmlData docId:strDocId type:strType];
				}
				
				//新报文声音效果
			}
			if ([strType isEqualToString:@"1"]) {
				//删除
				
			}
			else if ([strType isEqualToString:@"2"]) {
				//成功
				NSArray *docIdArray = [strDocId componentsSeparatedByString:@"&"];			
				NSInteger resultFlag = [[DataManager sharedManager] alterDocumentState:@"" documentId:[docIdArray objectAtIndex:0]  state:@"5"];
				
				if (resultFlag==0) {
					NSLog(@"OK"); 
				}else {
				}
			}else if ([strType isEqualToString:@"3"]) {
				//失败
				 NSArray *docIdArray = [strDocId componentsSeparatedByString:@"&"];
				 //当状态为0(未读)时,更改状态为1(已读)
				 NSInteger resultFlag = [[DataManager sharedManager] alterDocumentState:@"" documentId:[docIdArray objectAtIndex:0]  state:@"3"];
				 
				 if (resultFlag==0) {
					 NSLog(@"OK"); 
				 }else {
				 }
				
			}
		}
	}
	//数据确认
	[self documentConfirm];
	//
	if (isMore==1) {
		//如果more 标志为true 说明还有数据没取完，继续发送请求去取
		[self getDocumentData];
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

	/*
	//
	if (isMore==0) {
		//调用confirm 接口
		[self documentConfirm];
	}*/
	[docIdArray release];
}

//
- (void)checkAnimationIsDone{
	
	UIImageView *animationImageView = (UIImageView *)self.view;
	BOOL flag = [animationImageView isAnimating];
	if(!flag){
		[checkTimer invalidate];
		//
		[aiView setAlpha:1];
		[loadingLabel setAlpha:1];
		[aiView startAnimating];
		[self performSelectorOnMainThread:@selector(beginDataSyncWork) withObject:nil waitUntilDone:YES];
	}
	return;
}
//

//向服务器去cofirm data
-(void)documentConfirm{	
	//http://192.168.0.219:8080/tbaxis/servlet/document/iphone/confirm.do
	NSString *strURL = [[NSString alloc] initWithFormat:@"%@",kConfirmUrl];
	//strURL = [[NSString alloc] initWithFormat:@"%@",@"http://182.180.58.251:8080/tbaxis/servlet/document/iphone/confirm.do"];
	NSLog(@"%@",strURL);
	NSURL *url = [[NSURL alloc] initWithString:strURL];
	[strURL release];
	
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	NSString *httpBodyString = @"";
	NSMutableArray *arraySendData = [[NSMutableArray alloc] init];
	
	NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
	
	NSString *strUniquer =  [UIDevice currentDevice].uniqueIdentifier;
	NSLog(@"UUID %@ ",strUniquer);
	
    [headers setValue:strUniquer forKey:@"Techown-Request-Name"];
	//[headers setValue:@"a6032385a8ba2eed1277f3c3f283e7ee6a91c555" forKey:@"Techown-Request-Name"];

    [headers setValue:@"iphone" forKey:@"Techown-Request-Type"];
	
	[request setAllHTTPHeaderFields:headers];
	[request setTimeoutInterval:20.0];
	[arraySendData release];
	
	NSArray *array  = [[DataManager sharedManager] getDocIdList];
	NSMutableArray *arrayData = [[[NSMutableArray alloc] initWithArray:array] mutableCopy];

	NSMutableDictionary *dicConfirmData = [[NSMutableDictionary alloc] init];
	/*
	for (int i=0; i<[arrayData count]; i++) {
		
		NSMutableArray *confirmArray = [[NSMutableArray alloc] init];
		NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
		//[dic setValue:@"150021722&oa" forKey:@"docId"];
		//[dic setValue:@"0" forKey:@"type"];
		
		[confirmArray addObject:dic];
		//[dic release];
		//
		[dicConfirmData setValue:confirmArray forKey:@"documentComfirm"];
		[confirmArray release];
	}*/

	[dicConfirmData setValue:arrayData forKey:@"documentComfirm"];
	[dicConfirmData setValue:@"99999999999999999999999999999999999999999920199999999999999999999999" forKey:@"temp"];
	
	httpBodyString = [dicConfirmData JSONRepresentation];
	NSLog(@"httpBodyString %@",httpBodyString);
	NSData *postData = [httpBodyString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
	NSData *_postData = [LFCGzipUtility gzipDataTest:postData];
	//NSData *_postData = [LFCGzipUtility uncompress:postData];
	
	[request setHTTPBody:_postData]; 
		
	[request setHTTPMethod:@"POST"];
	//
	NSURLResponse *reponse;
	NSError *error = nil;
	NSString *responseString = nil;
	//
	NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
	//NSString *strRecive = @"{\"more\":\"false\",\"documentGroup\":[{\"data\":\"documentData\",\"docId\":\"001\",\"type\":\"0\"}]}";
	//responseData = [strRecive dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
	
	NSMutableDictionary *getDicData;
	if (error) {
		NSLog(@"Something wrong: %@",[error description]);
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

		//return;
	}else {
		if (responseData) {
			NSData *_data = [LFCGzipUtility uncompressZippedData:responseData];
			responseString = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
			NSLog(@" reciveData %@ ",responseString);
		}
	}
	//getArrayData = [strRecive JSONValue];
	//getDicData = [strRecive JSONValue];
	
	/*{
		"errorMsg":"操作成功",
		"resultInfo":"ok/error"
	}*/
	
	getDicData  = [responseString JSONValue];
	NSString *strResultInfo = [getDicData objectForKey:@"resultInfo"];
	if ([strResultInfo isEqualToString:@"ok"]) {
		NSLog(@"ok");
		
		//更改tblDocIdList 表中 state字段 值为1 说明该条记录已经确认过了
		NSInteger resultFlag = [[DataManager sharedManager] alterDocIdState:arrayData];
		if (resultFlag==0) {
			NSLog(@"OK"); 
		}
		
	}else if ([strResultInfo isEqualToString:@"error"]) {
		NSLog(@"error");
	}

	NSString *strErrorMsg = [getDicData objectForKey:@"errorMsg"];
	NSLog(@"errorMsg %@",strErrorMsg);
		
	[arrayData release];
	[dicConfirmData release];
	//[pool release];
}

//
- (void)beginDataSyncWork{

	
	//判断iphone 的网络状态
	if((NotReachable == [[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] ) && (NotReachable == [[Reachability reachabilityForInternetConnection] currentReachabilityStatus])){
		//网络有问题，给出提示
		NSLog(@"no network connection");
		UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"note" 
														 message:@"Error!" 
														delegate:self 
											   cancelButtonTitle:@"OK" 
											   otherButtonTitles:nil] autorelease];
		[alert show];
		
	}else{
		//kServerUrl
		NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kServerUrl]];
		//NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kServerUrl]];		
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
		[request setHTTPMethod:@"POST"];
		[request setTimeoutInterval:11];
		//
		NSURLResponse *reponse;
		NSError *error = nil;
		NSString *responseString = nil;
		NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
		[request release];
		if (error) {
			NSLog(@"Something wrong: %@",[error description]);
			UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"note" 
															 message:@"Connection failed!" 
															delegate:self 
												   cancelButtonTitle:@"OK" 
												   otherButtonTitles:nil] autorelease];
			[alert show];
			return;
		}else {
			if (responseData) {
				responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
				//NSLog(@"responseString  homepage %@",responseString);
				[NSThread detachNewThreadSelector:@selector(doDataSyncTask) toTarget:self withObject:nil];
			}
		}
	}
	 
	//[NSThread detachNewThreadSelector:@selector(doDataSyncTask) toTarget:self withObject:nil];
	return;
}


//2010-07-08  xyl  注释
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
	//GtFundAppDelegate *app = (GtFundAppDelegate *)[UIApplication sharedApplication].delegate;
	//[app dataSyncFinished:nil];
	return;
}
//
- (void)doDataSyncTask{
	//
	NSAutoreleasePool *pool =  [[NSAutoreleasePool alloc] init];

	//GtFundAppDelegate *app = (GtFundAppDelegate *)[UIApplication sharedApplication].delegate;
		
	//[self getDocumentData];//从中间件得到报文数据
	
	//[self documentConfirm];
	[self doWaitDownloading];
	//[app dataSyncFinished:nil];
	[pool release];
	return;
}
//
- (void)doWaitDownloading{
	[opQueue waitUntilAllOperationsAreFinished];
	return;
}
//

- (void)startSync{
	[NSThread detachNewThreadSelector:@selector(doDataSync) toTarget:self withObject:nil];
}
//
- (void)doDataSync{
	//
	//sleep(.1);
	NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
	[center postNotificationName:@"SYNC_FINISHED" object:nil];
	return;
	//
}
//

//
/*
 ":"用%$%代替
 "{"用$$%代替
 "}"用%$$代替
 "["用#$$代替
 "]"用$$#代替
 */
-(NSString *)stringReplacing:(NSString *)strSource{
	strSource = [strSource stringByReplacingOccurrencesOfString:@"%$%" withString:@":"];
	strSource = [strSource stringByReplacingOccurrencesOfString:@"$$%" withString:@"{"];
	strSource = [strSource stringByReplacingOccurrencesOfString:@"%$$" withString:@"}"];
	strSource = [strSource stringByReplacingOccurrencesOfString:@"#$$" withString:@"["];
	strSource = [strSource stringByReplacingOccurrencesOfString:@"$$#" withString:@"]"];
	return strSource;
}


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
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[databasePath release];
	[opQueue release];
    [super dealloc];
}


@end

