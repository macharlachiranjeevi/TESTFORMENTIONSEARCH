//
//  ViewController.h
//  Test
//
//  Created by chiranjeevi macharla on 17/01/17.
//  Copyright © 2017 chiranjeevi macharla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactsTVC.h"
@interface ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,ContactsTVCDelegate>
@property (strong, nonatomic) IBOutlet UITextView *CommentsTv;
@property (strong, nonatomic) IBOutlet UITableView *namesTbv;
@property(strong,nonatomic)NSMutableArray * contactsArray;
@property (strong, nonatomic) NSMutableArray  *filteredArray;
@property (strong, nonatomic) NSString        *mention;
@end

