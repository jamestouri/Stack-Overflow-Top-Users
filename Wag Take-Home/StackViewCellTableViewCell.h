//
//  StackViewCellTableViewCell.h
//  Wag Take-Home
//
//  Created by James touri on 6/11/18.
//  Copyright © 2018 jamestouri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StackViewCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) IBOutlet UIImageView *goldPicture;
@property (strong, nonatomic) IBOutlet UIImageView *silverPicture;
@property (strong, nonatomic) IBOutlet UIImageView *bronzePicture;

@property (strong, nonatomic) IBOutlet UILabel *goldAmount;
@property (strong, nonatomic) IBOutlet UILabel *silverAmount;
@property (strong, nonatomic) IBOutlet UILabel *bronzeAmount;


@end
