//
//  CSShowBrowser.m
//  eLearning
//
//  Created by sunon on 14-5-30.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import "CSShowBrowser.h"
#import "CSPhotoView.h"
#import "AppDelegate.h"
#define kImgTag     10001   //imgview tag
#define kViewTag    7777    //view tag
#define kNotificationSubViewsChange @"kNotificationSubViewsChange"  //子视图发生改变
@interface CSShowBrowser()
{
    CGRect oldFrame;
    NSInteger page;
    BOOL isShow;
//    CGFloat imgScale;
}
@property(nonatomic,strong)UIView* backView;
@property(nonatomic,strong)UIScrollView* scroll;
@property(nonatomic,strong)NSMutableArray* imgVArray;
@property(nonatomic,copy)UIImage* removeImg;
@end
@implementation CSShowBrowser
static CSShowBrowser* showBrowser;
+(CSShowBrowser *)shareInstance
{
    if (!showBrowser) {
        showBrowser=[[CSShowBrowser alloc] init];
    }
    return showBrowser;
}
-(void)showListBigImage:(NSMutableArray *)imgUrlArray imgVArray:(NSMutableArray *)imgVArray index:(NSInteger)index edit:(BOOL)edit
{
    if (isShow) {
        return;
    }else{
        isShow=!isShow;
    }
    self.imgVArray=imgVArray;
    page=index;
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView* bottomV=app.window;
    UIImageView* imgV=[imgVArray objectAtIndex:page];
    oldFrame=[imgV convertRect:imgV.bounds toView:bottomV];
    
    _backView=[[UIView alloc] initWithFrame:oldFrame];
    _backView.clipsToBounds=YES;
    _backView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8];
    [bottomV addSubview:_backView];
    
    _scroll=[[UIScrollView alloc] initWithFrame:bottomV.bounds];
    _scroll.delegate=self;
    _scroll.backgroundColor=[UIColor blackColor];
    _scroll.contentSize=CGSizeMake(bottomV.bounds.size.width*imgVArray.count, bottomV.bounds.size.height);
    _scroll.pagingEnabled=YES;
    _scroll.showsHorizontalScrollIndicator=NO;
    [_backView addSubview:_scroll];
    
    if (edit) {
        for (int i=0; i<[imgVArray count]; i++) {
            CSPhotoView* photoV=[[CSPhotoView alloc] initWithFrame:CGRectMake(bottomV.bounds.size.width*i, 0, bottomV.bounds.size.width, bottomV.bounds.size.height)];
            photoV.img=((UIImageView *)[imgVArray objectAtIndex:i]).image;
            photoV.tag=kImgTag+i;
            [_scroll addSubview:photoV];
        }
    }else{
        for (int i=0; i<[imgUrlArray count]; i++) {
            CSPhotoView* photoV=[[CSPhotoView alloc] initWithFrame:CGRectMake(bottomV.bounds.size.width*i, 0, bottomV.bounds.size.width, bottomV.bounds.size.height)];
            photoV.photoUrl=[imgUrlArray objectAtIndex:i];
            photoV.tag=i;
            [_scroll addSubview:photoV];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        _backView.frame=bottomV.bounds;
    }];
    
    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideBottomV)];
    [_scroll addGestureRecognizer:tap];
    
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [_scroll setContentOffset:CGPointMake(bottomV.bounds.size.width*page, 0) animated:NO];
    
    
    if (edit) {
        UIView* headV=[[UIView alloc] initWithFrame:CGRectMake(0, 0, bottomV.bounds.size.width, 64.0)];
        headV.backgroundColor=[UIColor blackColor];
        headV.tag=kViewTag;
        [_backView addSubview:headV];
        
        UIButton* leftBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame=CGRectMake(10.0, 20.0, 40.0, headV.bounds.size.height-20.0);
        [leftBtn setTitle:NSLocalizedString(@"返回", nil) forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(hideBottomV) forControlEvents:UIControlEventTouchUpInside];
        [headV addSubview:leftBtn];
        
        UIButton* rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame=CGRectMake(headV.bounds.size.width-50.0,20.0, 40.0, headV.bounds.size.height-20.0);
        [rightBtn setTitle:NSLocalizedString(@"删除", nil) forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
        [headV addSubview:rightBtn];
        
    }

   
    
}
-(void)hideBottomV
{
    isShow=NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIImageView* imgV=nil;
    if ([self.imgVArray count]>0) {
        imgV=[self.imgVArray objectAtIndex:page];
    }
    oldFrame=[imgV convertRect:imgV.bounds toView:_scroll.superview];
    [UIView animateWithDuration:0.3 animations:^{
        _backView.frame=oldFrame;
    }completion:^(BOOL finished){
        [_backView removeFromSuperview];
        self.backView=nil;
        self.scroll=nil;
        self.imgVArray=nil;
        self.removeImg=nil;
    
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    page=scrollView.contentOffset.x/scrollView.bounds.size.width;
    
}

-(void)delete
{
    NSMutableArray* photoArray=[NSMutableArray array];
    for (id obj in _scroll.subviews) {
        if ([obj isKindOfClass:[CSPhotoView class]]) {
            [photoArray addObject:obj];
        }
    }
    for (int i=0;i<[photoArray count];i++) {
        CSPhotoView* photoV=[photoArray objectAtIndex:i];
        if (i==page) {
            self.removeImg=photoV.img;
            [photoV removeFromSuperview];
            [photoArray removeObject:photoV];
            [_imgVArray removeObjectAtIndex:page];
            for (UIImageView* preImgV in _imgVArray) {
                if (preImgV.tag>page) {
                    preImgV.tag-=1;
                }
            }
            [UIView animateWithDuration:0.3 animations:^{
                _scroll.contentSize=CGSizeMake([_imgVArray count]*_scroll.bounds.size.width, _scroll.bounds.size.height);
            }];
        }
    }
    _scroll.contentSize=CGSizeMake(_scroll.bounds.size.width*photoArray.count, _scroll.bounds.size.height);
    [UIView animateWithDuration:0.3 animations:^{
        for (int i=0; i<[photoArray count]; i++) {
            CSPhotoView* photoV=[photoArray objectAtIndex:i];
            photoV.frame=CGRectMake(_scroll.bounds.size.width*i, 0, _scroll.bounds.size.width, _scroll.bounds.size.height);
        }
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSubViewsChange object:_removeImg];

}
//-(void)showBigImage:(UIImage *)img view:(UIView *)v
//{
//    
//    CSAppDelegate* app=(CSAppDelegate *)[UIApplication sharedApplication].delegate;
//    UIView* bottomView=app.window;
//   
//    _backView=[[UIView alloc] initWithFrame:bottomView.frame];
//    _backView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.8];
//    [bottomView addSubview:_backView];
//
//    
//    oldFrame=[v convertRect:v.bounds toView:_backView];
//   
//    _imageV=[[UIImageView alloc] init];
//    _imageV.frame=oldFrame;
//    [_backView addSubview:_imageV];
//    
//    UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImage:)];
//    [_backView addGestureRecognizer:tap];
//    
//    UIPinchGestureRecognizer* pinGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaGesture:)];
//    [_backView addGestureRecognizer:pinGesture];
//    
//    _imageV.image=img;
//    [UIView animateWithDuration:0.3 animations:^{
//        _imageV.frame=CGRectMake((_backView.frameWidth-img.size.width*2.0)/2.0, (_backView.frameHeight-img.size.height*2.0)/2.0, img.size.width*2.0, img.size.height*2.0);
//    }];
//}
//
//
//-(void)hideImage:(UITapGestureRecognizer *)tapGesture
//{
//    [UIView animateWithDuration:0.3 animations:^{
//        _imageV.frame=oldFrame;
//    }completion:^(BOOL finished){
//        [_backView removeFromSuperview];
//        self.backView=nil;
//        self.imageV=nil;
//        imgScale=0.0;
//    }];
//}

//-(void)scaGesture:(UIPinchGestureRecognizer *)gesture
//{
//    UIImage* img=_imageV.image;
//    if (gesture.state==UIGestureRecognizerStateBegan) {
//        imgScale=_imageV.frame.size.height/img.size.height;
//    }else if(gesture.state==UIGestureRecognizerStateChanged){
//        _imageV.frame=CGRectMake((_backView.frameWidth-img.size.width*imgScale*gesture.scale)/2.0, (_backView.frameHeight-img.size.height*imgScale*gesture.scale)/2.0, img.size.width*imgScale*gesture.scale, img.size.height*imgScale*gesture.scale);
//    }else if(gesture.state==UIGestureRecognizerStateEnded){
//        imgScale=_imageV.frame.size.height/img.size.height;
//    }
//}
@end
