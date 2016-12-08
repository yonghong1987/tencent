//
//  CSProjectListView.m
//  tencent
//
//  Created by bill on 16/4/26.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSProjectListView.h"
#import "CSProjectCollectionViewCell.h"
#import "CSProjectListViewController.h"

#import "CSProjectDefault.h"
#import "CSFrameConfig.h"
#import "AppDelegate.h"
#import "CSBaseNavigationController.h"
#import "MBProgressHUD+SMHUD.h"
#import "CSProjectListViewController.h"
#define kProjectCollectionViewCell @"ProjectCollectionViewCell"

@interface CSProjectListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *projectCollectionView;

@end

@implementation CSProjectListView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (NSString *)getChoiceKey:(NSInteger)row{
    
    return [NSString stringWithFormat:@"%ld",(long)row];
    
}
- (void)reloadData{
    
    [self.projectCollectionView reloadData];
}


#pragma mark delegate method
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake( kCSScreenWidth/3 , 120);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake( 0, 0, 0, 0);
}

- (CGFloat)minimumInteritemSpacing {
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return [self.dataSourceAry count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView*)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CSProjectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kProjectCollectionViewCell forIndexPath:indexPath];
//    cell.showType = self.showType;
  CSProjectItemModel *model = self.dataSourceAry[indexPath.row];
    [cell setProjectModel:self.dataSourceAry[indexPath.row]];
    
    switch ( _showType ) {
        case TYPE_SHOWPROJ:{
            [cell.choiceMarkImg setImage:[UIImage imageNamed:@""]];
        }
            break;
        case TYPE_CHOICEPROJ:{
            
            if ( [self.choiceMarkDic objectForKey:[NSString stringWithFormat:@"%ld",[model.projectId integerValue]]] ) {
                [cell.choiceMarkImg setImage:[UIImage imageNamed:@"icon_choose"]];
            }else{
                [cell.choiceMarkImg setImage:[UIImage imageNamed:@""]];
            }
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    CSProjectItemModel *model = self.dataSourceAry[indexPath.row];
    
    switch ( _showType ) {
        case TYPE_SHOWPROJ:{

            if ( self.choiceProject ) {
                if ( [model.projectId integerValue] == 0 ) {
                    self.choiceProject(0);
                }else{
                    if ( [model.projectId isEqualToNumber:[[CSProjectDefault shareProjectDefault] getProjectId]] ) {
                         self.choiceProject(1);
                    }else{
                        [[CSProjectDefault shareProjectDefault] saveProjectId:model.projectId];
                        [[CSProjectDefault shareProjectDefault] saveProjectName:model.appName];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kChangeProjectNotifycation object:nil];
                        self.choiceProject(2);
                        [self.delegate.navigationController popViewControllerAnimated:YES];
                    }
                }
            }
        }
            break;
        case TYPE_CHOICEPROJ:{
            
            if ([self.delegate isKindOfClass:[CSProjectListViewController class]]) {
                CSProjectListViewController *listViewVC = (CSProjectListViewController *)self.delegate;
                if( [[self.choiceMarkDic allKeys] containsObject:[NSString stringWithFormat:@"%ld",[model.projectId integerValue]]] ){
                    
                    [self.choiceMarkDic removeObjectForKey:[NSString stringWithFormat:@"%ld",[model.projectId integerValue]]];
                    listViewVC.title = [NSString stringWithFormat:@"常用项目（%d/5)",[listViewVC.projectDic.allKeys count]];
                    
                }else{
                    
                    if ( [[self.choiceMarkDic allKeys] count] < 5 ) {
                        
                        [self.choiceMarkDic setValue:[(CSProjectItemModel *)model projectId]
                                              forKey:[NSString stringWithFormat:@"%ld",[model.projectId integerValue]]];
                        listViewVC.title = [NSString stringWithFormat:@"常用项目（%d/5)",[listViewVC.projectDic.allKeys count]];
                    }else{
                        
                        [MBProgressHUD  showToView:self text:@"设置不能超过5个项目" hideBlock:nil];
                        
                    }
                    
                }
                [self reloadData];
                
            }
            
        }
            break;
        default:
            break;
    }
}


#pragma mark init method
- (UICollectionView *)projectCollectionView{
    
    if ( !_projectCollectionView ) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.footerReferenceSize  = CGSizeMake(0, 0);
        
        layout.sectionInset            = UIEdgeInsetsMake(0, 0, 0, 0);
        layout.minimumInteritemSpacing = 0.0;
        layout.minimumLineSpacing      = 0.0;
        
        _projectCollectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _projectCollectionView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"project_bg"]];
        _projectCollectionView.alwaysBounceVertical = YES;
        _projectCollectionView.delegate = self;
        _projectCollectionView.dataSource = self;
        [_projectCollectionView registerNib:[UINib nibWithNibName:@"CSProjectCollectionViewCell" bundle:nil]
                 forCellWithReuseIdentifier:kProjectCollectionViewCell];
        [self addSubview:_projectCollectionView];
    }
    return _projectCollectionView;
}


- (void)setDataSourceAry:(NSMutableArray *)dataSourceAry{
    _dataSourceAry = [NSMutableArray arrayWithArray:dataSourceAry];
}

- (NSMutableDictionary *)choiceMarkDic{

    if ( !_choiceMarkDic ) {
        _choiceMarkDic = [NSMutableDictionary dictionary];
    }
    return _choiceMarkDic;
}
@end
