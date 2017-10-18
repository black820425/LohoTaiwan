//
//  DetailTableViewCell.m
//  LohoTaiwan
//
//  Created by 黃柏恩 on 2017/9/26.
//  Copyright © 2017年 黃柏恩. All rights reserved.
//

#import "DetailTableViewCell.h"

@implementation DetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    //self.imageView.center = CGPointMake(self.contentView.bounds.size.width/2,self.contentView.bounds.size.height/2);
    //self.imageView.center = CGPointMake(0,0);
//    CGSize size = self.contentView.bounds.size;
//    self.textLabel.frame = CGRectMake(10, 10, size.width, size.height);
//    [self.textLabel setNumberOfLines:0];
//    self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

@end
