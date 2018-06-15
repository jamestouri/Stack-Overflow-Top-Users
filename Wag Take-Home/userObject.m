//
//  userObject.m
//  Wag Take-Home
//
//  Created by James touri on 6/13/18.
//  Copyright © 2018 jamestouri. All rights reserved.
//

#import "userObject.h"
@implementation UserObject
-(instancetype)initWithDictionary:(NSDictionary *)user {
    if (self = [super init]) {
        _userID = user[@"user_id"];
        _badges = user[@"badges"];
        _name = user[@"display_name"];
        _image = user[@"image"];
    }
    return self;
}
@end

