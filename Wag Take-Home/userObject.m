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
        self.userID = user[@"user_id"];
        self.badges = user[@"badges"];
        self.name = user[@"display_name"];
        self.image = user[@"image"];
    }
    return self;
}
@end

