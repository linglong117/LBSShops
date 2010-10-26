//
//  CommentCell.h
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-16.
//  Copyright 2010 sino. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CommentCell : UITableViewCell {
	UILabel * txtComment;
}

@property (nonatomic, retain) IBOutlet UILabel * txtComment;

@end
