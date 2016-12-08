//
//  CSPhotoView.m
//  eLearning
//
//  Created by sunon on 14-6-19.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import "CSPhotoView.h"
#import "UIImageView+AFNetworking.h"
@interface CSPhotoView()
{
    CGFloat imgScale;
}
@property(nonatomic,strong)UIActivityIndicatorView* activityV;
@property(nonatomic,strong)UIImageView* imgV;
@end

@implementation CSPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds=YES;
        
        _imgV=[[UIImageView alloc] init];
        _imgV.userInteractionEnabled=YES;
        [self addSubview:_imgV];
        UIPinchGestureRecognizer* pinGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaGesture:)];
        [self addGestureRecognizer:pinGesture];
        

        _activityV=[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.bounds.size.width-40.0)/2.0,(self.bounds.size.height-40.0)/2.0, 40.0, 40.0)];
        _activityV.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
        [self addSubview:_activityV];
        [_activityV startAnimating];
        
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

-(void)setPhotoUrl:(NSString *)photoUrl
{
    _photoUrl=photoUrl;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_photoUrl]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    __weak UIImageView *weakImg=_imgV;
    __weak UIView* weakSelf=self;
    __weak UIActivityIndicatorView* weakActivity=_activityV;
    UIImage* defaultImg=[UIImage imageNamed:@"default_image"];
     weakImg.frame=CGRectMake((weakSelf.frame.size.width-defaultImg.size.width)/2.0, (weakSelf.frame.size.height-defaultImg.size.height)/2.0, defaultImg.size.width, defaultImg.size.height);
    
    [_imgV setImageWithURLRequest:request placeholderImage:defaultImg success:^(NSURLRequest* request,NSHTTPURLResponse* response,UIImage *image){
        __strong UIImageView* strongImg = weakImg;
        __strong UIActivityIndicatorView* strongActivity=weakActivity;
        [strongActivity stopAnimating];
        if (image.size.width>weakSelf.frame.size.width||image.size.height>weakSelf.frame.size.height) {
            CGFloat widthScale=weakSelf.frame.size.width/(image.size.width);
            CGFloat heightScale=weakSelf.frame.size.height/(image.size.height);
            CGFloat chooseScale=(widthScale>heightScale?heightScale:widthScale);
            strongImg.frame=CGRectMake((weakSelf.bounds.size.width-image.size.width*chooseScale)/2.0, (weakSelf.bounds.size.height-image.size.height*chooseScale)/2.0, image.size.width*chooseScale, image.size.height*chooseScale);
        }else{
            strongImg.frame=CGRectMake((weakSelf.bounds.size.width-image.size.width)/2.0, (weakSelf.bounds.size.height-image.size.height)/2.0, image.size.width, image.size.height);
        }
        strongImg.image=image;
    } failure:^(NSURLRequest* request,NSHTTPURLResponse* response,NSError* error){
        [weakActivity stopAnimating];
    
    }];
}


-(void)scaGesture:(UIPinchGestureRecognizer *)gesture
{
    UIImage* img=_imgV.image;
    if (gesture.state==UIGestureRecognizerStateBegan) {
        imgScale=_imgV.frame.size.height/img.size.height;
    }else if(gesture.state==UIGestureRecognizerStateChanged){
        _imgV.frame=CGRectMake((self.frame.size.width-img.size.width*imgScale*gesture.scale)/2.0, (self.frame.size.height-img.size.height*imgScale*gesture.scale)/2.0, img.size.width*imgScale*gesture.scale, img.size.height*imgScale*gesture.scale);
    }else if(gesture.state==UIGestureRecognizerStateEnded){
        imgScale=_imgV.frame.size.height/img.size.height;
    }
}


-(void)setImg:(UIImage *)img
{
    _img=img;
    [_activityV stopAnimating];
    if (img.size.width>self.frame.size.width||img.size.height>self.frame.size.height) {
        CGFloat widthScale=self.frame.size.width/(img.size.width);
        CGFloat heightScale=self.frame.size.height/(img.size.height);
        CGFloat chooseScale=(widthScale>heightScale?heightScale:widthScale);
        _imgV.frame=CGRectMake((self.bounds.size.width-img.size.width*chooseScale)/2.0, (self.bounds.size.height-img.size.height*chooseScale)/2.0, img.size.width*chooseScale, img.size.height*chooseScale);
    }else{
        _imgV.frame=CGRectMake((self.frame.size.width-img.size.width)/2.0, (self.frame.size.height-img.size.height)/2.0,img.size.width, img.size.height);
    }
    
    _imgV.image=img;
}
@end
