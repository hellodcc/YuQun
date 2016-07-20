//
//  ImageCell.m
//  YuQun
//
//  Created by 董冲冲 on 16/3/23.
//  Copyright © 2016年 董冲冲. All rights reserved.
//

#import "ImageCell.h"
#import "AHeader.h"
@implementation ImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.masksToBounds=YES;
        _imageView.layer.cornerRadius=10;
        _imageView.layer.borderWidth=1;
        _imageView.layer.borderColor=COLOR_BACK.CGColor;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
}

@end
