//
//  CSShowView.m
//  eLearning
//
//  Created by sunon on 14-5-15.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import "CSShowView.h"
#import "CSShowBrowser.h"
#import "UIView+convenience.h"
#define kNotificationSubViewsChange @"kNotificationSubViewsChange"  //子视图发生改变
@interface CSShowView()
@property(nonatomic,strong)NSMutableArray* imgArray;
@property(nonatomic,assign)CGFloat marginLeft;
@end

@implementation CSShowView
@synthesize marginLeft;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        self.imgArray=[NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changelayout:) name:kNotificationSubViewsChange object:nil];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)addImage:(UIImage *)img
{
    if (marginLeft<5.0) {
        marginLeft=5.0;
    }
    UIImageView* imgV=[[UIImageView alloc] initWithImage:img];
    imgV.userInteractionEnabled=YES;
    imgV.tag=[_imgArray count];
    [self addSubview:imgV];
    UITapGestureRecognizer* tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editShowView:)];
    tapGesture.numberOfTouchesRequired=1;
    [imgV addGestureRecognizer:tapGesture];
    
    if ([_imgArray count]==0) {
        imgV.frame=CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    }else{
        UIImageView* lastImg=[_imgArray lastObject];
        imgV.frame=CGRectMake(lastImg.frameRight+marginLeft,0,self.frame.size.height,self.frame.size.height);
    }
    [_imgArray addObject:imgV];
    if ((self.frame.size.height+marginLeft)*_imgArray.count>self.frame.size.width) {
        [UIView animateWithDuration:0.3 animations:^{
            for (int i=0; i<_imgArray.count; i++) {
                UIImageView* imgV=[_imgArray objectAtIndex:i];
                CGRect vRect=imgV.frame;
                vRect.origin.x-=35.0;
                imgV.frame=vRect;
            }
        
        }];
    }
    
}
-(void)editShowView:(UITapGestureRecognizer *)tap
{
    UIImageView* imgV=(UIImageView *)tap.view;
    if (_delegate&&[_delegate respondsToSelector:@selector(resignFirstResponder)]) {
        [_delegate resginFirstResponse];
    }
//    JQImagePreviewController *previewVC = [[JQImagePreviewController alloc] init];
//    previewVC.images = self.imgArray;
//    previewVC.currentIndex = imgV.tag;
//    [previewVC setEndPreviewBlock:^(NSMutableArray * image) {
//        self.imgArray = image;
//        [self.collectionView reloadData];
//    }];
//    [self.parentController presentViewController:previewVC animated:YES completion:nil];
    
    CSShowBrowser* showBrowser=[CSShowBrowser shareInstance];
    [showBrowser showListBigImage:nil imgVArray:self.imgArray index:imgV.tag edit:YES];
}


-(void)changelayout:(NSNotification *)notification
{
    UIImage* img=notification.object;
    if (img!=nil) {
        if (_delegate&&[_delegate respondsToSelector:@selector(removeImg:)]) {
            [_delegate removeImg:img];
        }
    }
    NSLog(@"delete operation");
    for (UIImageView* imgV  in self.subviews) {
        [imgV removeFromSuperview];
    }
    for (int i=0; i<[self.imgArray count]; i++) {
        UIImageView* imgV=[self.imgArray objectAtIndex:i];
        if (i==0) {
            imgV.frame=CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
        }else{
            UIImageView* lastImgV=[self.imgArray objectAtIndex:(i-1)];
            imgV.frame=CGRectMake(lastImgV.frameRight+marginLeft,0,self.frame.size.height,self.frame.size.height);
        }
        [self addSubview:imgV];
        if ((self.frame.size.height+marginLeft)*(i+1)>self.frame.size.width) {
            [UIView animateWithDuration:0.3 animations:^{
                for (int j=0;j<=i; j++) {
                    UIImageView* imgV=[_imgArray objectAtIndex:j];
                    CGRect vRect=imgV.frame;
                    vRect.origin.x-=35.0;
                    imgV.frame=vRect;
                }
                
            }];
        }
    }
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
