//
//  ContactsTVC.m
//  Test
//
//  Created by chiranjeevi macharla on 17/01/17.
//  Copyright © 2017 chiranjeevi macharla. All rights reserved.
//

#import "ContactsTVC.h"

@implementation ContactsTVC

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapOnselectionBtn:(id)sender {
    if ([_delegate respondsToSelector:@selector(namePressed:)])
    {
        [_delegate namePressed:self.contactNamelbl.text];
    }

}
@end
