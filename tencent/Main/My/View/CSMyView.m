//
//  CSMyView.m
//  tencent
//
//  Created by bill on 16/5/23.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSMyView.h"
#import "UIView+SDAutoLayout.h"
#import "CSFrameConfig.h"
#import "CSConfig.h"
#import "CSColorConfig.h"
#import "UIImageView+AFNetworking.h"
#import "CSUserModel.h"
#import "CSUserDefaults.h"
#import "CSImagePath.h"
#import "CSAppVersionModel.h"

@interface CSMyView ()<UITableViewDelegate,UITableViewDataSource>



@property (nonatomic, strong) NSDictionary *myCenterInfo;

@property (nonatomic, strong) NSArray *dataSourceAry;
@property (nonatomic, strong) UIButton *badgeBtn2;
@end

@implementation CSMyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if ( self ) {
        [self addSubview:self.myCenterTable];
    }
    return self;
}

#pragma mark UItableView Delegate Mehtod
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSourceAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"123"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        //设置背景色块
        UIImageView *backView = [[UIImageView alloc] initWithFrame:CGRectMake( 8, 0, self.bounds.size.width - 16, 46)];
        backView.backgroundColor = [UIColor whiteColor];
        [cell.contentView addSubview:backView];
 
        cell.textLabel.sd_layout
        .topSpaceToView(cell.contentView, 12)
        .leftSpaceToView(cell.contentView, 18)
        .bottomSpaceToView(cell.contentView, 21)
        .widthIs(100);
        
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textColor = kTitleColor;
        [cell.textLabel updateLayout];
    }

    //设置样式
    NSInteger indexRow = indexPath.row;
    if(  indexRow == 0 || indexRow == 1 || indexRow == 2 ){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    //设置标题
    cell.textLabel.text = self.dataSourceAry[indexPath.row];
 
    //设置特定内容
    if ( indexRow == 3 ) {
        UILabel *versionLbl = [[UILabel alloc] initWithFrame:CGRectMake( 90, 19, 150, 9)];
        versionLbl.text = LOCALVERSION;
        versionLbl.font = [UIFont systemFontOfSize:9];
        versionLbl.textColor = kTimeColor;
        versionLbl.tag = 1000;
        [cell.contentView addSubview:versionLbl];
        
        CSAppVersionModel *model = [CSAppVersionModel shareInstance];
        
        if ( [model compareVersion] == NSOrderedDescending ) {
            UILabel *markLbl = [[UILabel alloc] initWithFrame:CGRectMake( kCSScreenWidth - 90, 17, 70, 11)];
            markLbl.text = @"New";
            markLbl.font = [UIFont systemFontOfSize:14];
            markLbl.tag = 1001;
            markLbl.textAlignment = NSTextAlignmentRight;
            markLbl.textColor = [UIColor colorWithRed:244.0/255 green:85.0/255 blue:77.0/255 alpha:1];
            [cell.contentView addSubview:markLbl];
        }
        
    }else if (indexRow == 2){
        self.badgeBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        self.badgeBtn2.frame = CGRectMake(kCSScreenWidth - 40, 20, 15, 15);
        self.badgeBtn2.layer.cornerRadius = 7.5;
        self.badgeBtn2.layer.masksToBounds = YES;
        [self.badgeBtn2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.badgeBtn2.backgroundColor = [UIColor redColor];
        self.badgeBtn2.titleLabel.font = [UIFont systemFontOfSize:11.0];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *commentCount = [ud objectForKey:@"commentBadgeCount"];
        [ud synchronize];
        if ([commentCount isEqualToString:@"0"]) {
            [self.badgeBtn2 setHidden:YES];
        }else{
            [self.badgeBtn2 setHidden:NO];
            [self.badgeBtn2 setTitle:commentCount forState:UIControlStateNormal];
            
        }
        [cell.contentView addSubview:self.badgeBtn2];
    }
    else{
        
        UILabel *versionLbl = [cell.contentView viewWithTag:1000];
        [versionLbl removeFromSuperview];
        
        UILabel *markLbl = [cell.contentView viewWithTag:1001];
        [markLbl removeFromSuperview];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        [self.badgeBtn2 setHidden:YES];
    }
    [self responseToSelected:(indexPath.row+4)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSArray *viewAry = [[NSBundle mainBundle] loadNibNamed:@"CSMyHeadView" owner:nil options:nil];
    
    self.tableHeadView = viewAry[0];
    CGRect frame = self.bounds;
    frame.size.height = 284;
    self.tableHeadView.frame = frame;
    
    
    UIButton *headBtn = [self.tableHeadView viewWithTag:1000];
    headBtn.layer.cornerRadius = 61;
    headBtn.clipsToBounds = YES;
    headBtn.backgroundColor = [UIColor whiteColor];
    [headBtn setBackgroundImage:[UIImage imageNamed:@"backiv2"] forState:UIControlStateNormal];
    [headBtn addTarget:self action:@selector(responseToBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *photoView = [self.tableHeadView viewWithTag:1001];
    photoView.layer.cornerRadius = 45;
    photoView.clipsToBounds = YES;
    
    CSUserModel *userModel = [[CSUserDefaults shareUserDefault] getUser];
    [photoView setImageWithURL:[NSURL URLWithString:[CSImagePath getImageUrl:userModel.img]] placeholderImage:[UIImage imageNamed:@"user"]];
    
    
    UILabel *nickName = [self.tableHeadView viewWithTag:2000];
    nickName.text = userModel.name;
    
    UILabel *departInfo = [self.tableHeadView viewWithTag:2001];
    departInfo.text = userModel.department;
    
    UIButton *learnRecordBtn = [self.tableHeadView viewWithTag:1];
    [learnRecordBtn addTarget:self action:@selector(responseToBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *practiseRecordBtn = [self.tableHeadView viewWithTag:2];
    [practiseRecordBtn addTarget:self action:@selector(responseToBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *selfTipBtn = [self.tableHeadView viewWithTag:3];
    [selfTipBtn addTarget:self action:@selector(responseToBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *forumCount = [ud objectForKey:@"forumBadgeCount"];
    [ud synchronize];
    
    UIButton *badgeBtn = [self.tableHeadView viewWithTag:4];
    badgeBtn.layer.cornerRadius = 7.5;
    badgeBtn.layer.masksToBounds = YES;
    [badgeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    badgeBtn.titleLabel.font = [UIFont systemFontOfSize:11.0];
    if ([forumCount isEqualToString:@"0"]) {
        [badgeBtn setHidden:YES];
    }else{
        [badgeBtn setHidden:NO];
        [badgeBtn setTitle:forumCount forState:UIControlStateNormal];

    }
        return self.tableHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 292;
}

- (void)responseToTapGes:(UITapGestureRecognizer *)tapGes{
    [self responseToSelected:0];
}

- (void)responseToBtn:(UIButton *)sender{
    [self responseToSelected:sender.tag%1000];
    if (sender.tag == 3) {
       UIButton *badgeBtn = [self.tableHeadView viewWithTag:4];
        [badgeBtn setHidden:YES];
    }
}

- (void)responseToSelected:(NSInteger)selectedIndex{
    if ( self.selectedRowIndex ) {
        self.selectedRowIndex(selectedIndex);
    }
}

#pragma mark init
- (UITableView *)myCenterTable{
    
    if ( !_myCenterTable ) {
        
        CGRect frame = self.bounds;
        frame.size.height -= 20;
        _myCenterTable = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
        _myCenterTable.delegate = self;
        _myCenterTable.dataSource = self;
        _myCenterTable.rowHeight = 54;
        _myCenterTable.separatorStyle = UITableViewCellSelectionStyleNone;
        _myCenterTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _myCenterTable.backgroundColor = kBGColor;
     }
    return _myCenterTable;
}

- (NSDictionary *)myCenterInfo{
    if ( _myCenterInfo ) {
        _myCenterInfo = [NSDictionary dictionary];
    }
    return _myCenterInfo;
}


- (void)setSelectedRowIndex:(selectedRowIndex)selectedRowIndex{
    if ( !_selectedRowIndex ) {
        _selectedRowIndex = selectedRowIndex;
    }
}


- (NSArray *)dataSourceAry{
    if ( !_dataSourceAry ) {
        _dataSourceAry = @[@"我的收藏",@"我的下载",@"我的评论",@"当前版本",@"退出账号"];
    }
    return _dataSourceAry;
}

- (void)setDataSourceInfo:(NSDictionary *)dataSource{
    
    self.myCenterInfo = [NSDictionary dictionaryWithDictionary:dataSource];
    [self.myCenterTable reloadData];
}
@end
