//
//  ContactsTVC.h
//  Test
//
//  Created by chiranjeevi macharla on 17/01/17.
//  Copyright © 2017 chiranjeevi macharla. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContactsTVCDelegate <NSObject>

- (void) namePressed:(NSString*) currentUserName;

@end
@interface ContactsTVC : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *contactNamelbl;
@property (strong, nonatomic) IBOutlet UIButton *selectionbtn;
- (IBAction)didTapOnselectionBtn:(id)sender;
@property (nonatomic, weak) id delegate;

@end
