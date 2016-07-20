//
//  TZPhotoPreviewCell.h
//  TZImagePickerController
//
//  Created by dcc on 15/10/29.
//  Copyright © 2015年 dcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TZAssetModel;
@interface TZPhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) TZAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)();

@end
