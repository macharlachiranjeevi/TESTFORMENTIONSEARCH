//
//  ViewController.m
//  Test
//
//  Created by chiranjeevi macharla on 17/01/17.
//  Copyright © 2017 chiranjeevi macharla. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
@interface ViewController ()
{
    NSMutableArray * words;
    NSString *typingText;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.CommentsTv.delegate = self;
    self.contactsArray = [ NSMutableArray new];
    self.filteredArray = [ NSMutableArray new];
    [_CommentsTv setContentOffset: CGPointMake(0,0) animated:NO];
    words = [NSMutableArray new];
    [self contactsDetailsFromPhoneContactBook];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)textViewDidChange:(UITextView *)textView
{

//    if(self.CommentsTv.text.length == 0){
//        self.CommentsTv.textColor = [UIColor lightGrayColor];
//        self.CommentsTv.text = @"Comment";
//        [self.CommentsTv resignFirstResponder];
//    }
      typingText = textView.text;
    NSArray *mentions = [self findMentions:typingText];

    if(mentions.count > 0) {
        // words = [[text componentsSeparatedByString:@" "] mutableCopy];
        self.mention = mentions[0];
        [self searchNameForMention:mentions[0]];
        self.namesTbv.hidden = NO;
    } else {
        self.namesTbv.hidden = YES;
    }


    NSLog(@"%s: %@", __func__, [self findMentions:typingText]);

}
//- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
//{
//    _CommentsTv.text = @"";
//    _CommentsTv.textColor = [UIColor blackColor];
//    return YES;
//}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{


    return YES;
}

#pragma mark - Find mentions

- (NSMutableArray *)findMentions:(NSString *)text
{

    NSError *error = nil;

    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"(@[a-zA-Z]+)"
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:&error];

    NSMutableArray *mentions = [NSMutableArray array];

    NSArray *matches = [regex matchesInString:text options:0 range:NSMakeRange(0, [text length])];

    for (NSTextCheckingResult *result in matches) {

        [mentions addObject:[text substringWithRange:result.range]];

    }

    return mentions;

}
- (void)searchNameForMention:(NSString *)mention {
    NSString *name = [mention substringFromIndex:1];
    [self.filteredArray removeAllObjects];

    NSPredicate *pFilter = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@", name];

    self.filteredArray   = [NSMutableArray arrayWithArray:[self.contactsArray filteredArrayUsingPredicate:pFilter]];

    [self.namesTbv reloadData];
}


-(void)contactsDetailsFromPhoneContactBook{
    CNContactStore *store = [[CNContactStore alloc] init];
    [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted == YES) {
            //keys with fetching properties
            NSArray *keys = @[CNContactFamilyNameKey,CNContactGivenNameKey];
            NSString *containerId = store.defaultContainerIdentifier;
            NSPredicate *predicate = [CNContact predicateForContactsInContainerWithIdentifier:containerId];
            NSError *error;
            NSArray *cnContacts = [store unifiedContactsMatchingPredicate:predicate keysToFetch:keys error:&error];
            if (error) {
                NSLog(@"error fetching contacts %@", error);
            } else {
                NSString *fullName;
                NSString *firstName;
                NSString *lastName;
                for (CNContact *contact in cnContacts) {
                    // copy data to my custom Contacts class.
                    firstName = contact.givenName;
                    lastName = contact.familyName;
                    if (lastName == nil) {
                        fullName=[NSString stringWithFormat:@"%@",firstName];
                    }else if (firstName == nil){
                        fullName=[NSString stringWithFormat:@"%@",lastName];
                    }
                    else{
                        fullName=[NSString stringWithFormat:@"%@ %@",firstName,lastName];
                    }
                    [self.contactsArray addObject:fullName];

                    NSLog(@"working or not %@",self.contactsArray);
                }
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self. namesTbv reloadData];
//                });
            }
        }
    }];
}
#pragma UITableview delegate and datasource methods

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return UITableViewAutomaticDimension;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return _filteredArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{


    static NSString *cellIdentifier = @"ContactsTVC";
    ContactsTVC *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.contactNamelbl.text = [_filteredArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;

}

#pragma delegate of contact tableview cell
- (void) namePressed:(NSString *)currentUserName
{


NSArray *arr = [_CommentsTv.text componentsSeparatedByString:@"@"];

    NSString *ContSt = [arr lastObject];
  NSString * contactStr =  [ContSt stringByReplacingOccurrencesOfString:ContSt withString:currentUserName];
    NSLog(@"ContaCT NAME = %@" , contactStr);

    if (![_CommentsTv.text containsString:contactStr]) {
_CommentsTv.text = [_CommentsTv.text stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"@%@",ContSt] withString:currentUserName];
    }

     NSLog(@"ContaCT NAME FINAL = %@" , _CommentsTv.text);
    [self.filteredArray removeAllObjects];;
    [self.namesTbv setHidden:YES];
}

@end
