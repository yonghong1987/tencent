//
//  CSSpecialDetailCell.m
//  tencent
//
//  Created by admin on 16/5/5.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSSpecialDetailCell.h"
#import "UIView+SDAutoLayout.h"
#import "MBProgressHUD+CYH.h"
#import "CSConfig.h"
#import "CSFrameConfig.h"
#import "MBProgressHUD+CYH.h"
#import "NSDictionary+convenience.h"
#import "CSGlobalMacro.h"
#import "CSProjectDefault.h"
#import "CSNormalCourseDetailViewController.h"
#import "CSForumDetailViewController.h"
#import "CSStudyCaseDetailViewController.h"
#import "CSSpecialDetailViewController.h"
#import "CSMapCheckPointViewController.h"
#import "CSExamContentViewController.h"
#import "CSStudyMapModel.h"
@implementation CSSpecialDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 高度必须提前赋一个值 >0
        self.detailWebView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 0, [[UIScreen mainScreen] bounds].size.width - 20 , 1)];
        //        self.detailWebView.opaque = NO;
        self.detailWebView.userInteractionEnabled = YES;
        self.detailWebView.scrollView.bounces = NO;
//        self.detailWebView.scalesPageToFit = YES;
        self.detailWebView.delegate = self;
        self.detailWebView.paginationBreakingMode = UIWebPaginationBreakingModePage;
        [self.contentView addSubview:self.detailWebView];
        
    }
    return self;
}

-(void)setSpecialListModel:(CSSpecialListModel *)specialListModel{
    _specialListModel = specialListModel;
    [self.detailWebView loadHTMLString:self.specialListModel.content baseURL:nil];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.superview];
    // 如果要获取web高度必须在网页加载完成之后获取
    //    CGSize fittingSize = [self.detailWebView sizeThatFits:CGSizeZero];
    
    self.height = webView.scrollView.contentSize.height;//fittingSize.height;
    self.detailWebView.frame = CGRectMake(0, 0, kCSScreenWidth,  self.height);
    // 用通知发送加载完成后的高度
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WEBVIEW_HEIGHT" object:self userInfo:nil];
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
//    [MBProgressHUD showLoadingToView:self.superview];
    
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.superview];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString *originStr=request.URL.relativeString;
        NSArray* array=[originStr componentsSeparatedByString:@"/"];
        NSString *subStr=[array lastObject];
        NSArray  * arrParam =[subStr componentsSeparatedByString:@"&"];
        NSMutableDictionary * dicParam = [[NSMutableDictionary alloc] initWithCapacity:arrParam.count];
        for(NSString *param in arrParam) {
            NSMutableArray *oneParam = (NSMutableArray *)[param componentsSeparatedByString:@"="];
            if([oneParam containsObject:@""])
                [oneParam removeObject:@""];
            [dicParam setValue:[oneParam lastObject] forKey:[oneParam firstObject]];
        }
        NSString *typeValue = [dicParam stringForKey:OpenURLType];
        if(typeValue.length==0) {
            return YES;
        }
        //将项目id保存
        NSInteger projectIdValue = [dicParam integerForKey:OpenURLProjectId];
        [[CSProjectDefault shareProjectDefault] saveProjectId:[NSNumber numberWithInteger:projectIdValue]];
        //跳转到课程详情
        if ([typeValue isEqualToString:URLParamOnline]) {
            NSInteger courseId = [dicParam integerForKey:OpenURLCourseId];
            CSNormalCourseDetailViewController *normalCource = [[CSNormalCourseDetailViewController alloc]initWithCourseId:[NSNumber numberWithInteger:courseId] CoureseName:nil];
            [self.viewController.navigationController pushViewController:normalCource animated:YES];
            //跳转到考试
        }else if ([typeValue isEqualToString:URLParamExam]){
            CSExamContentViewController *examVC = [[CSExamContentViewController alloc]init];
            examVC.examActivityId = [NSNumber numberWithInteger:[dicParam integerForKey:OpenURLActivityId]];
            examVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:examVC animated:YES];
        //跳转到帖子详情
        }else if ([typeValue isEqualToString:URLParamForum]){
            NSInteger forumId = [dicParam integerForKey:OpenURLForumId];
            CSForumDetailViewController *forumDetail = [[CSForumDetailViewController alloc]init];
            forumDetail.forumId = [NSNumber numberWithInteger:forumId];
            [self.viewController.navigationController pushViewController:forumDetail animated:YES];
            //跳转到案列详情
        }else if ([typeValue isEqualToString:URLParamCase]){
        NSInteger caseId = [dicParam integerForKey:OpenURLCaseId];
            CSStudyCaseDetailViewController *studyCase = [[CSStudyCaseDetailViewController alloc]init];
            studyCase.caseId = [NSNumber numberWithInteger:caseId];
            [self.viewController.navigationController pushViewController:studyCase animated:YES];
            //跳转到专题详情
        }else if ([typeValue isEqualToString:URLParamTopic]){
            NSInteger courseId = [dicParam integerForKey:OpenURLCourseId];
            CSSpecialDetailViewController *specialDetail = [[CSSpecialDetailViewController alloc]init];
            specialDetail.specialid = [NSNumber numberWithInteger:courseId];
            [self.viewController.navigationController pushViewController:specialDetail animated:YES];
            //跳转到地图列表
        }else if ([typeValue isEqualToString:URLParamMap]){
            NSInteger courseId = [dicParam integerForKey:OpenURLMapId];
            CSMapCheckPointViewController *mapVC = [[CSMapCheckPointViewController alloc]init];
            CSStudyMapModel *mapModel = [[CSStudyMapModel alloc]init];
            mapModel.mappId = [NSNumber numberWithInteger:courseId];
            mapVC.mapModel = mapModel;
            [self.viewController.navigationController pushViewController:mapVC animated:YES];
        }
    }
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
