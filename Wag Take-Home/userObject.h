//
//  userObject.h
//  Wag Take-Home
//
//  Created by James touri on 6/13/18.
//  Copyright © 2018 jamestouri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UserObject : NSObject

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSDictionary *badges;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *image;


-(instancetype)initWithDictionary:(NSDictionary *)user;
@end
