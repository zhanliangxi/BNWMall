//
//  BNWAddressCell.m
//  BNWMail
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWAddressCell.h"
#import "BNWAddress.h"

@interface BNWAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation BNWAddressCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"BNWAddressCell";
    BNWAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[BNWAddressCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    return cell;
}

- (void)setAddress:(BNWAddress *)address
{
    _address = address;
    
    self.nameLabel.text = address.name;
    
    self.phoneNumberLabel.text = address.phoneNumber;
    
    self.addressLabel.text = address.address;
}

@end
