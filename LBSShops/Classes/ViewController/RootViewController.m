    //
//  RootViewController.m
//  LBSShops
//
//  Created by xie yilong on 10-10-25.
//  Copyright 2010 xyl. All rights reserved.
//

#import "RootViewController.h"


@implementation RootViewController

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
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
	UIImageView *contentView = [[UIImageView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [contentView setImage:[UIImage imageNamed:@"Default0.png"]];
    [contentView setUserInteractionEnabled:YES];
    self.view = contentView;
    [contentView release];
	
	[self.view setBackgroundColor:[UIColor blackColor]];
	//
	NSArray* imageNames = [NSArray arrayWithObjects:
						   @"gticon.png",
						   @"cwxx.png",
						   @"IconAnimal.png",
						   @"logo1.png",
						   @"logo2.png",
						   @"set.png",
						   @"logo2.png",
						   @"set.png",
						   @"ydxs.png",
						   @"gticon.png",
						   @"IconAnimal.png", nil];
	
	NSArray *titleNames = [NSArray arrayWithObjects:
						   @"分类查询",
						   @"签到",
						   @"优惠券",
						   @"调查问卷",
						   @"附近",
						   @"缤纷活动",
						   @"积分",
						   @"电子账单",
						   @"我的收藏",
						   @"切换城市",
						   @"关于我们测试", nil];
	
	
    UIButton *btn;
	UILabel *btnTitle;
	
    for (int i=0; i<[imageNames count]; i++) {
		
        CGRect btnRect;
		CGRect titleRect;
        btn = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		btnTitle = [[UILabel alloc] init];
		
        [btn setImage:[UIImage imageNamed:[imageNames objectAtIndex: i]] forState:UIControlStateNormal];//设置按钮图片
        btn.tag = i;
		btnTitle.tag=i;
		
        btnRect.size.width = 57;//设置按钮坐标及大小
        btnRect.size.height = 57;
        btnRect.origin.x = (i%4)*(57+20)+16;
        btnRect.origin.y = floor(i/4)*(57+30)+16;
		[btn setFrame:btnRect];
		
		UIFont *font = [UIFont boldSystemFontOfSize:12];
		//[UIFont fontWithName:@"Arial" size:18];
		titleRect.size.width = btnRect.size.width + 16;
		titleRect.size.height = 12;
		titleRect.origin.x = btnRect.origin.x - 8;
		titleRect.origin.y = btnRect.origin.y + btnRect.size.height + 5;
		btnTitle.frame = titleRect;
		btnTitle.font = font;
		btnTitle.textColor = [UIColor whiteColor];
		btnTitle.textAlignment = UITextAlignmentCenter;
		btnTitle.backgroundColor = [UIColor clearColor];
		btnTitle.text = [titleNames objectAtIndex:i];
		[self.view addSubview:btnTitle];
		[btnTitle release];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn release];
		
    }
}

//响应按钮事件

-(void)btnPressed:(id)sender{
	
    UIButton *btn = (UIButton *)sender;
	int index = btn.tag;
    switch (index) {
        case 0:{
			NSLog(@"0");
			/*
			 if(mobileController==nil){
			 
			 mobileController = [[MobileController alloc]init];
			 }
			 
			 [self.navigationController pushViewController:mobileController animated:YES];
			 */
		}
            break;
			//其他几个控制器类似
    }
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
