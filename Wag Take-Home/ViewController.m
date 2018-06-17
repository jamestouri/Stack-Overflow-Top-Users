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
    
    
    //Started the activity indicator here
    StackViewCellTableViewCell *cell = [[StackViewCellTableViewCell alloc] init];
    [cell.activityIndicator startAnimating];
    
    self.allUsers = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    
    // Making the call from StackExchange Endpoint API
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
    
    // Stopping activity indicator when image runs
    [cell.activityIndicator stopAnimating];
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
            
            // Unique paths for the Documents Directory
            NSString *picturePath = [[NSString alloc] init];
            picturePath = [NSString stringWithFormat:@"%@.png", user.name];
            
            link = info[@"profile_image"];

            // Calling the finding image function
            img = [self findingImage: (NSString *) picturePath givenLink: (NSString *) link ];
            
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

#pragma mark - findingImage


-(UIImage *) findingImage: (NSString *) picturePath givenLink: (NSString *) link {
    
    UIImage *image = [[UIImage alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths lastObject]; //create NSString object, that holds our exact path to the documents directory
    NSString *workSpacePath=[documentsDirectory stringByAppendingPathComponent:picturePath];

    // If images haven't been downloaded then download them from the web for future offline use
    if  ([UIImage imageWithData:[NSData dataWithContentsOfFile:workSpacePath]] == nil) {
    
        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: link]];
        image = [UIImage imageWithData: imageData];
        
        NSData *dataImage = UIImagePNGRepresentation(image);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:picturePath];
        [fileManager createFileAtPath:fullPath contents:dataImage attributes:nil];
        
    } else {
        
        // If the photos are saved for retrieval in the documents directory
        image = [UIImage imageWithContentsOfFile:workSpacePath];
        
    }

    
    
    
//    NSString *filePath = picturePath;
//    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
//        NSLog(@"it exists");
//        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//
//        NSString *pngFilePath = [NSString stringWithFormat:@"%@/%@", docDir, picturePath];
//
//        NSData *dataImage = [NSData dataWithContentsOfFile:pngFilePath];
//        UIImage *image = [UIImage imageWithData:dataImage];
//        return image;
//
//    } else {
//        NSLog(@"doesn't exist");
//        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: link]];
//        UIImage *image = [UIImage imageWithData: imageData];
//
//
//        NSString *documentaryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *filePath = [NSString stringWithFormat:picturePath,documentaryPath];
//        NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)];
//        [data writeToFile:filePath atomically:YES];
//        return image;
//
//    }
//
    
    return image;
    
}



@end
