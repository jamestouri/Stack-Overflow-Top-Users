//
//  ViewController.m
//  Wag Take-Home
//
//  Created by James touri on 6/11/18.
//  Copyright © 2018 jamestouri. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>
#import "userObject.h"
#import "StackViewCellTableViewCell.h"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *allUsers;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.allUsers = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    
    // Making the call from the StackExchange Data
    [self jsonCall];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// Table View Functions

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *tableCell = @"cell";
    
    UserObject *appointedUser = self.allUsers[indexPath.row];

    StackViewCellTableViewCell *cell = (StackViewCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCell forIndexPath:indexPath];
    
    // Assigning the objects
    cell.name.text = appointedUser.name;

    cell.profilePicture.image = appointedUser.image;
    
    // Values were Int type
    cell.goldAmount.text = [NSString stringWithFormat:@"%@", appointedUser.badges[@"gold"]];
    cell.silverAmount.text = [NSString stringWithFormat:@"%@", appointedUser.badges[@"silver"]];
    cell.bronzeAmount.text = [NSString stringWithFormat:@"%@", appointedUser.badges[@"bronze"]];

    return cell;
}


// JSON Call for the Stack Exchange API
-(void) jsonCall {
    // URL Call
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.stackexchange.com/2.2/users?site=stackoverflow"]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];
        NSArray *requestReply = [json objectForKey:@"items"];
        // Putting inside Temporary Array before giving to Global Array
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        
        // Iterating through the items key
        for (NSDictionary *info in requestReply) {
            
            UserObject *user = [[UserObject alloc] init];
            
            UIImage *img = [[UIImage alloc] init];
            NSString *link = [[NSString alloc] init];
            
            user.userID = info[@"account_id"];
            user.badges = info[@"badge_counts"];
            user.name = info[@"display_name"];
            
            
            
            link = info[@"profile_image"];
            NSLog(@"%@", link);
            // Get from JSON API
            NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: link]];
            img = [UIImage imageWithData: imageData];
            
            user.image = img;
            
            // Pushing to User Object
            [tempArray addObject:user];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // After iterating through now putting in the global array
            self.allUsers = tempArray;
            [self.tableView reloadData];
        });
    }]
     resume];
}

@end
