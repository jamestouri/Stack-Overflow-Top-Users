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
@property (weak, nonatomic) NSMutableArray *allUsers;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    _allUsers = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    // Calling the UserObject Class
    UserObject *user = [[UserObject alloc] init];
    
    // Making the call
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://api.stackexchange.com/2.2/users?site=stackoverflow"]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                             options:kNilOptions
                                                               error:&error];

        NSArray *requestReply = [json objectForKey:@"items"];
        // Putting inside Temporart Array
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        // Storing the values in the right variables
        
        
        for (NSDictionary *info in requestReply) {
            UIImage *img = [[UIImage alloc] init];
            NSString *url = [[NSString alloc] init];
            
            user.userID = info[@"account_id"];
            user.badges = info[@"badge_counts"];
            user.name = info[@"display_name"];
            url = info[@"display_name"];
            
            @try {
                
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                     NSUserDomainMask, YES);
                NSString *documentsDirectory = paths.firstObject;
                NSString *cname = [documentsDirectory stringByAppendingFormat:@"Profile-Images/%@.png", url];
                
                
                img = [UIImage imageNamed:cname];
                
            }
            
            @catch (NSException *exception) {
                // Get from JSON API
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
                img = [UIImage imageWithData: imageData];
                
                //Store to documents
                NSFileManager *fileManager= [NSFileManager defaultManager];
                [[NSFileManager defaultManager] createFileAtPath:[NSString stringWithFormat:@"Profile-Images/%@.png", url] contents:nil attributes:nil];
                [imageData writeToFile:[NSString stringWithFormat:@"Profile-Images/%@.png", url] atomically:YES];
                
            }
            
            @finally {
                
                user.image = img;
            }
            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _allUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCell = @"Cell";
    
    UserObject *theUser = _allUsers[indexPath.row];
                           
    StackViewCellTableViewCell *cell = (StackViewCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableCell];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Cell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Assigning the objects
    cell.name.text = theUser.name;
    
    cell.profilePicture.image = theUser.image;
    
    cell.goldAmount.text = theUser.badges[@"gold"];
    cell.silverAmount.text = theUser.badges[@"silver"];
    cell.bronzeAmount.text = theUser.badges[@"bronze"];

    return cell;
    
}

@end
