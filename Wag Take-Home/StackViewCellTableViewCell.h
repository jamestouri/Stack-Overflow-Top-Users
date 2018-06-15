//
//  StackViewCellTableViewCell.h
//  Wag Take-Home
//
//  Created by James touri on 6/11/18.
//  Copyright © 2018 jamestouri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackViewCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIImageView *goldPicture;
@property (weak, nonatomic) IBOutlet UIImageView *silverPicture;
@property (weak, nonatomic) IBOutlet UIImageView *bronzePicture;

@property (weak, nonatomic) IBOutlet UILabel *goldAmount;
@property (weak, nonatomic) IBOutlet UILabel *silverAmount;
@property (weak, nonatomic) IBOutlet UILabel *bronzeAmount;


@end
