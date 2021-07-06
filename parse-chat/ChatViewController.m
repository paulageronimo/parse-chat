//
//  ChatViewController.m
//  parse-chat
//
//  Created by Paula Leticia Geronimo on 7/6/21.
//

#import "ChatViewController.h"
#import <Parse/Parse.h>
#import "ChatCell.h"

@interface ChatViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *chatBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *arrayOfMessages;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(onRefresh) userInfo:nil repeats:true];
    // Do any additional setup after loading the view.
}

- (IBAction)onSend:(id)sender {
    PFObject *chatMessage = [PFObject objectWithClassName:@"Message_FBU2021"];
    // Use the name of your outlet to get the text the user typed
    chatMessage[@"text"] = self.chatBar.text;
    chatMessage[@"user"] = PFUser.currentUser;
    //[query includeKey:@"user"];
    
    [chatMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (succeeded) {
            NSLog(@"The message was saved!");
            self.chatBar.text = @"";
        } else {
            NSLog(@"Problem saving message: %@", error.localizedDescription);
        }
    }];
    
}

-(void)onRefresh {
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Message_FBU2021"];
    [query orderByDescending:@"createdAt"];
    [query includeKey:@"user"];
    query.limit = 20;
    
    // fetch data asynchronously
    [query findObjectsInBackgroundWithBlock:^(NSArray *posts, NSError *error) {
        if (posts != nil) {
            // do something with the array of object returned by the call
            self.arrayOfMessages = posts;
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
    
    [self.tableView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatCell" forIndexPath:indexPath];
    // NSString *message = self.arrayOfMessages[indexPath.row];
    // should be an NSDictionary instead of string
    NSDictionary *message = self.arrayOfMessages[indexPath.row];
    // cell.message.text = message;
    cell.message.text = message[@"text"];
    PFUser *user = message[@"user"];
    if (user != nil) {
        // User found! update username label with username
        cell.user.text = user.username;
    } else {
        // No user found, set default username
        cell.user.text = @"🤖";
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfMessages.count;
}



@end
