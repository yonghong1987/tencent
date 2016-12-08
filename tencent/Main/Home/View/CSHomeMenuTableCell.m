//
//  CSHomeMenuTableCell.m
//  tencent
//
//  Created by sunon002 on 16/4/27.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSHomeMenuTableCell.h"
#import "CSHomeCollectionCell.h"
#import "CSFrameConfig.h"
#import "CSColorConfig.h"
#import "CSRepositoryViewController.h"
#import "CSBaseNavigationController.h"
#import "AppDelegate.h"

#import "CSHotRankViewController.h"
#import "CSSpecialViewController.h"
#import "UIColor+HEX.h"

@implementation CSHomeMenuTableCell

static NSString *const kMenuItemCell = @"MenuItemCell";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setModel:(NSString *)model
{
    [self initUI];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height - 20);
}

#pragma mark controlInit
-(void)initUI{
    //流式布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0.0;
    layout.minimumInteritemSpacing = 0.0;
    //背景默认是黑色的
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-20, self.frame.size.height - 20) collectionViewLayout:layout];
    self.collectionView.backgroundColor = CSColorFromRGB(235.0, 235.0, 235.0);
    //设置代理
    self.collectionView.delegate = self;
    //数据源代理
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerClass:[CSHomeCollectionCell class] forCellWithReuseIdentifier:kMenuItemCell];
    [self addSubview:self.collectionView];
    self.menuItems = @[@"专题推荐",@"知识库",@"热门排行"];
    self.icons = @[@"icon_zhuantituijian",@"icon_zhishiku",@"icon_remenpaihang"];
    self.colors = @[CSColorFromRGB(90.0, 201.0, 116.0),CSColorFromRGB(119.0, 133.0, 146.0),[UIColor colorWithHexString:@"#e4644a"]];
}



#pragma mark - UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.menuItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kMenuItemCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    cell.itemTitleLabel.text = self.menuItems[indexPath.row];
    cell.itemIcon.image = [UIImage imageNamed:self.icons[indexPath.row]];
    cell.backgroundColor = self.colors[indexPath.row];
    if (indexPath.row == 0 || indexPath.row == 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(cell.frame.size.width - 40, 20, 20, 20);
        button.layer.cornerRadius = 10.0;
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor redColor];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        if (indexPath.row == 0) {
            if (self.seminarTotal > 0) {
                [button setTitle:[NSString stringWithFormat:@"%d",self.seminarTotal] forState:UIControlStateNormal];
            }else{
                [button setHidden:YES];
            }
        }else if (indexPath.row == 1){
            if (self.knowLedgeTotal > 0) {
                [button setTitle:[NSString stringWithFormat:@"%d",self.knowLedgeTotal] forState:UIControlStateNormal];
            }else{
                [button setHidden:YES];
            }
        }
        
        [cell.contentView addSubview:button];
        
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *currentVC = nil;
    switch ( indexPath.row) {
        case 0:{
            //专题推荐
            CSSpecialViewController *specialVC = [[CSSpecialViewController alloc] init];
            specialVC.hidesBottomBarWhenPushed = YES;
            specialVC.title = @"专题推荐";
            CSHomeCollectionCell *cell = (CSHomeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            for (UIView *view in cell.contentView.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
            currentVC = specialVC;
        }
            break;
        case 1:{
            //知识库
            CSRepositoryViewController *projectList = [[CSRepositoryViewController alloc] initWithCategoryId:[NSNumber numberWithInteger:0]
                                                                                                CategoryName:@"知识库"];
            projectList.hidesBottomBarWhenPushed = YES;
            CSHomeCollectionCell *cell = (CSHomeCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
            for (UIView *view in cell.contentView.subviews) {
                if ([view isKindOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
            currentVC = projectList;
        }
            break;
        case 2:{
            //热门排行
            CSHotRankViewController *hotRank = [[CSHotRankViewController alloc] init];
            hotRank.hidesBottomBarWhenPushed = YES;
            hotRank.title = @"热门排行";
            currentVC = hotRank;
        }
            break;
        default:
            break;
    }
    
    if( currentVC ){
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UITabBarController *tabBar = (UITabBarController *)delegate.window.rootViewController;
        CSBaseNavigationController *baseNav = (CSBaseNavigationController *)tabBar.selectedViewController;
        [baseNav pushViewController:currentVC animated:YES];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    return CGSizeMake((kCSScreenWidth-40)/3, (kCSScreenWidth-40)/3 - 10);
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
