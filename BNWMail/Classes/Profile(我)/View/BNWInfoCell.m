//
//  BNWInfoCell.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWInfoCell.h"

@interface BNWInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *labelView;

@end

@implementation BNWInfoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)cellWithAccount:(BNWAccount *)account didIndex:(NSInteger)index{
    
    switch (index) {
        case 0:{
            self.labelView.text = account.user_name;
            break;
        }
           
            
        case 1:{
            self.labelView.text = account.sex.integerValue == 0  ? @"保密" : ((account.sex.integerValue ==1 ) ? @"男" : @"女") ;
            break;
        }
            
            
        case 2:{
            self.labelView.text = account.mobile_phone;
            break;
        }

        default:
            break;
    }

}

@end
