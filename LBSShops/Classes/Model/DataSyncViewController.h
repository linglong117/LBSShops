
#import <UIKit/UIKit.h>
#import <sqlite3.h>

@class Reachability;


@interface DataSyncViewController : UIViewController {
	UIActivityIndicatorView *aiView;
	sqlite3		*database;
	NSString	*databasePath;
	NSOperationQueue	*opQueue;
	Reachability *hostReach;
    Reachability *internetReach;
    Reachability *wifiReach;
	//
	BOOL		isSameTimeDesc;
	//
	NSTimer *checkTimer;
	UILabel *loadingLabel;
	
	NSTimer *timer;//每隔一定的时间向服务器发送请求，看看有没有最新的报文
	//Boolean isMore;//是否还有未读的报文 true 没有新报文   false 还有未读的新报文 继续向服务器去取
	NSInteger isMore; //是否还有未读的报文 1 没有新报文   0 还有未读的新报文 继续向服务器去取
	
	//DocumentParser *documentParser;
	
}

@property (nonatomic,retain) IBOutlet UIActivityIndicatorView *aiView;
@property (nonatomic,retain) IBOutlet UILabel *loadingLabel;
//@property (nonatomic, retain) DocumentParser *documentParser;
@property (nonatomic,retain) NSTimer *timer;


- (void)startSync;
-(NSString *)stringReplacing:(NSString *)strSource;
- (void)doWaitDownloading;
- (void)beginDataSyncWork;

-(void)getDocumentData;//从中间件取的报文数据
-(void)saveDocumentData:(NSMutableDictionary *)getDicData;
-(void)documentConfirm;
//
@end
