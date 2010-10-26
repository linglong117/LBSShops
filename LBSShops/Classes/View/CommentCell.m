//
//  CommentCell.m
//  LBSShops
//
//  Created by Zhou Weikuan on 10-9-16.
//  Copyright 2010 sino. All rights reserved.
//

#import "CommentCell.h"


@implementation CommentCell

@synthesize txtComment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[txtComment release];
	
    [super dealloc];
}


@end
