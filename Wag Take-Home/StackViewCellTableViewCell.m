//
//  StackViewCellTableViewCell.m
//  Wag Take-Home
//
//  Created by James touri on 6/11/18.
//  Copyright © 2018 jamestouri. All rights reserved.
//

#import "StackViewCellTableViewCell.h"

@implementation StackViewCellTableViewCell

@synthesize profilePicture = _profilePicture;
@synthesize name = _name;

@synthesize goldPicture = _goldPicture;
@synthesize silverPicture = _silverPicture;
@synthesize bronzeAmount = _bronzePicture;

@synthesize goldAmount = _goldAmount;
@synthesize silverAmount = _silverAmount;
@synthesize bronzePicture = _bronzeAmount;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
