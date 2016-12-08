//
//  CSProjectCollectionViewCell.m
//  tencent
//
//  Created by bill on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSProjectCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CSProjectCollectionViewCell ()

@property (strong, nonatomic) IBOutlet UIImageView *projectImg;

@property (strong, nonatomic) IBOutlet UILabel *projectName;

@end

@implementation CSProjectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.projectImg.layer.cornerRadius = 32.0;
    self.projectImg.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setProjectModel:(CSProjectItemModel *)model{
    
    self.projectName.text = model.appName;
    /**
     *  显示全部的时候，图片从本地取
     */
    if( [model.projectId integerValue] == 0 ){
        self.projectImg.image = [UIImage imageNamed:@"img_more"];
    }else{
        [self.projectImg setImageWithURL:[NSURL URLWithString:model.img]
                        placeholderImage:[UIImage imageNamed:@"catalog_default"]];
    }

    
    
   
}

@end
