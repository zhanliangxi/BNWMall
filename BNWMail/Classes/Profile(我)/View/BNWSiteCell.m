//
//  BNWSiteCell.m
//  BNWMail
//
//  Created by iOSLX1 on 15/8/12.
//  Copyright (c) 2015年 yb. All rights reserved.
//

#import "BNWSiteCell.h"
#import "BNWSite.h"
#import "MJExtension.h"

@interface BNWSiteCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteLabel;

@property (strong,nonatomic) NSMutableArray *provinceList;
@property (strong,nonatomic) NSMutableArray *cityList;
@property (strong,nonatomic) NSMutableArray *areaList;
@end

@implementation BNWSiteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)editSite {
    
    if ([self.delegate respondsToSelector:@selector(siteCellWithEditSite:)]) {
        [self.delegate siteCellWithEditSite:self];
    }
    
}
- (IBAction)delSite {
    
    if ([self.delegate respondsToSelector:@selector(siteCellWithDelSite:)]) {
        [self.delegate siteCellWithDelSite:self];
    }
}

- (void)setUserSite:(BNWUserSite *)userSite{
    _userSite = userSite;
    self.nameLabel.text = userSite.consignee;
    self.phoneLabel.text = userSite.mobile;

    NSString *provinceStr = nil;
    for (BNWSite *site in self.provinceList) {
        if ([site.region_id isEqualToString:userSite.province]) {
            provinceStr = site.region_name;
        }
    }
    NSString *cityStr = nil;
    for (BNWSite *site in self.cityList) {
        if ([site.region_id isEqualToString:userSite.city]) {
            cityStr = site.region_name;
        }
    }
    NSString *areaStr = nil;
    for (BNWSite *site in self.areaList) {
        if ([site.region_id isEqualToString:userSite.district]) {
            areaStr = site.region_name;
        }
    }
    
    self.siteLabel.text = [NSString stringWithFormat:@"%@%@%@%@",provinceStr,cityStr,areaStr,userSite.address];
}
- (NSMutableArray *)provinceList{
    if (_provinceList == nil) {
        _provinceList = [BNWSite objectArrayWithFilename:@"consignee.plist"];
    }
    return _provinceList;
}
- (NSMutableArray *)cityList{
    if (_cityList == nil) {
        _cityList = [BNWSite objectArrayWithFilename:@"city.plist"];
    }
    return _cityList;
}
- (NSMutableArray *)areaList{
    if (_areaList == nil) {
        _areaList =  [BNWSite objectArrayWithFilename:@"district.plist"];
    }
    return _areaList;
}
@end
