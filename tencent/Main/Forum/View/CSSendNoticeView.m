  //
//  CSSendNoticeView.m
//  eLearning
//
//  Created by sunon on 14-5-7.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import "CSSendNoticeView.h"
//#import "CSFunction.h"
#import "NSString+convenience.h"
#import "CSFrameConfig.h"
#import "UIView+convenience.h"
#import "CSViewController.h"
#import "UIImage+convenience.h"

#import "TZImagePickerController.h"
#define TEXT_LENGTH 250
@interface CSSendNoticeView()
@property(nonatomic,strong)UIView *contentV;
@property(nonatomic,strong)UIButton *cancelBtn, *submitBtn, *cameraBtn, *chooseBtn;
@property(nonatomic,strong)UILabel* titleLb;
@property(nonatomic,strong)UITextView* textV;
@property(nonatomic,strong)UILabel* placeholderLb;
@property(nonatomic,weak)id<CSSendNoticeDelegate> delegate;
@property(nonatomic,strong)NSMutableArray* imgs;
@property(nonatomic,strong)CSShowView* showV;
@property CSSendNoticeType sendType;
@property (nonatomic, strong) UILabel *counterLabel;//输入的字符长度
@end
@implementation CSSendNoticeView
@synthesize leftMargin,corneradius;
@synthesize imgs;
@synthesize showV;
-(id)initWithTitle:(NSString *)title delegate:(id)delegate leftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle csSendType:(CSSendNoticeType)type
{
    self=[super init];
    if (self) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
        _delegate=delegate;
        _sendType=type;
        _contentV=[[UIView alloc] init];
         _contentV.backgroundColor=[UIColor whiteColor];
        self.title = title;
        self.imgs=[NSMutableArray array];
        _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag=0;
        [_cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_cancelBtn setTitle:NSLocalizedString(leftTitle, nil) forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [_cancelBtn addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        [ _contentV addSubview:_cancelBtn];
        
        _titleLb=[[UILabel alloc] init];
        _titleLb.textAlignment=NSTextAlignmentCenter;
        _titleLb.textColor=[UIColor blackColor];
        _titleLb.font=[UIFont systemFontOfSize:16.0f];
        _titleLb.backgroundColor=[UIColor clearColor];
        _titleLb.text=NSLocalizedString(title, nil);
        [ _contentV addSubview:_titleLb];
        
        _submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.tag=1;
        [_submitBtn setTitle:NSLocalizedString(rightTitle, nil) forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn.titleLabel.font=[UIFont systemFontOfSize:16];
        [ _contentV addSubview:_submitBtn];
        
        
        _textV=[[UITextView alloc] init];
        _textV.delegate=self;
        _textV.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.3].CGColor;
        _textV.layer.borderWidth = 1.0;
        [ _contentV addSubview:_textV];
        
        _placeholderLb=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100.0, 20.0)];
        _placeholderLb.backgroundColor=[UIColor clearColor];
        _placeholderLb.font=[UIFont systemFontOfSize:13.0f];
        _placeholderLb.text=@"添加评论...";
        _placeholderLb.textColor=[UIColor lightGrayColor];
        [_textV addSubview:_placeholderLb];
        
               
        if (_sendType==CSSendNoticeTypePicture) {
            _cameraBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cameraBtn setImage:[UIImage imageNamed:@"icon_photo"]  forState:UIControlStateNormal];
            [_contentV addSubview:_cameraBtn];
            
            _chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_chooseBtn setImage:[UIImage imageNamed:@"icon_camera"] forState:UIControlStateNormal];
            [_contentV addSubview:_chooseBtn];
            
            showV=[[CSShowView alloc] init];
            showV.delegate=self;
            [_contentV addSubview:showV];
        }
 
        [self addSubview: _contentV];

        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}


-(id)initWithTitle:(NSString *)title delegate:(id)delegate leftBtnImage:(UIImage *)leftImg rightBtnImage:(UIImage *)rightImg csSendType:(CSSendNoticeType)type
{
    self=[super init];
    if (self) {
        self.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.6];
        _delegate=delegate;
        _sendType=type;
        _contentV=[[UIView alloc] init];
        _contentV.backgroundColor=[UIColor whiteColor];
        self.title = title;
        self.imgs=[NSMutableArray array];
        _cancelBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.tag=0;
        [_cancelBtn setImage:leftImg  forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        [ _contentV addSubview:_cancelBtn];
        
        _titleLb=[[UILabel alloc] init];
        _titleLb.textAlignment=NSTextAlignmentCenter;
        _titleLb.textColor=[UIColor blackColor];
        _titleLb.font=[UIFont systemFontOfSize:16.0f];
        _titleLb.text=NSLocalizedString(title, nil);
        _titleLb.backgroundColor=[UIColor clearColor];
        [ _contentV addSubview:_titleLb];
        
        _submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.tag=1;
        [_submitBtn setImage:rightImg  forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(pressed:) forControlEvents:UIControlEventTouchUpInside];
        [ _contentV addSubview:_submitBtn];
        
        
        _textV=[[UITextView alloc] init];
        _textV.font=[UIFont systemFontOfSize:15.0f];
        _textV.delegate=self;
        
        _textV.layer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.3].CGColor;
        _textV.layer.borderWidth = 1.0;
        [ _contentV addSubview:_textV];
        
        self.counterLabel=[[UILabel alloc]init];
        self.counterLabel.text=@"250";
        self.counterLabel.textAlignment = NSTextAlignmentCenter;
        self.counterLabel.font=[UIFont systemFontOfSize:12.0];
        [_contentV addSubview:self.counterLabel];

        
        if ([title isEqualToString:@"评论"]) {
            _placeholderLb=[[UILabel alloc] initWithFrame:CGRectMake(5,5, 100.0, 20.0)];
            _placeholderLb.backgroundColor=[UIColor clearColor];
            _placeholderLb.textColor=[UIColor lightGrayColor];
            _placeholderLb.text=@"添加评论....";
            _placeholderLb.font=[UIFont systemFontOfSize:15.0f];
            [_textV addSubview:_placeholderLb];
        }
      
        
        if (_sendType==CSSendNoticeTypePicture) {
            _cameraBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_cameraBtn setImage:[UIImage imageNamed:@"icon_camera"]  forState:UIControlStateNormal];
            [_cameraBtn addTarget:self action:@selector(takenPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [_contentV addSubview:_cameraBtn];
            
            _chooseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_chooseBtn addTarget:self action:@selector(choosePic:) forControlEvents:UIControlEventTouchUpInside];
            [_chooseBtn setImage:[UIImage imageNamed:@"icon_photo"] forState:UIControlStateNormal];
            [_contentV addSubview:_chooseBtn];
            
            
            showV=[[CSShowView alloc] init];
            showV.delegate=self;
            [_contentV addSubview:showV];
        }
        
        [self addSubview: _contentV];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWillHiden:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>0) {
        _placeholderLb.hidden=YES;
    }else{
        _placeholderLb.hidden=NO;
    }
    if (textView.markedTextRange==nil&&textView.text.length>TEXT_LENGTH) {
        textView.text=[textView.text substringToIndex:TEXT_LENGTH];
    }
    int length=TEXT_LENGTH-textView.text.length;
    self.counterLabel.text=[NSString stringWithFormat:@"%d",length<0?0:length];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
  
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
-(void)pressed:(id)sender
{
    NSMutableDictionary* dict=[NSMutableDictionary dictionary];
    if ([_textV.text GetRidOfBlank].length>0) {
        [dict setObject:[_textV.text removeEmojiInStr] forKey:@"content"];
    }
    [dict setObject:imgs forKey:@"images"];
    UIButton* btn=(UIButton *)sender;
    if (_delegate&&[_delegate respondsToSelector:@selector(alertNotificeView:clickButtonAtIndex:params:)]) {
        [_delegate alertNotificeView:self clickButtonAtIndex:btn.tag params:dict];
    }
    [self hide];
   
}
-(void)hide
{
    [_textV resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [UIView animateWithDuration:0.2 animations:^{
        if (_sendType==CSSendNoticeTypePicture) {
            _contentV.frame=CGRectMake(leftMargin,kCSScreenWidth, kCSScreenWidth-leftMargin*2, 190.0);
        }else{
            _contentV.frame=CGRectMake(leftMargin,kCSScreenWidth, kCSScreenWidth-leftMargin*2, 170.0);
        }
    } completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

-(void)show//显示
{
    if ([_delegate isKindOfClass:[UIViewController class]]) {
        UIViewController* vc=(UIViewController *)_delegate;
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController* nav=(UINavigationController *)vc.parentViewController;
            if ([nav.parentViewController isKindOfClass:[UITabBarController class]]) {
                self.frame=nav.parentViewController.view.frame;
                [nav.parentViewController.view addSubview:self];
            }else{
                self.frame=vc.parentViewController.view.frame;
                [nav.view addSubview:self];
            }
        }else if([vc.parentViewController isKindOfClass:[UITabBarController class]]){
            self.frame=vc.parentViewController.view.frame;
            [vc.parentViewController.view addSubview:self];
        }else{
            self.frame=vc.view.frame;
            [vc.view addSubview:self];
        }
    }else if([_delegate isKindOfClass:[UIView class]]){
        UIView* v=(UIView *)_delegate;
        
        UIResponder *nextResponder = [v nextResponder];
        while(![nextResponder isKindOfClass:[UIViewController class]]) {
            nextResponder = nextResponder.nextResponder;
        }
        UIViewController* vc = (UIViewController *)nextResponder;
//        UIViewController* vc=[CSFunction accordingViewfindViewController:v];
        if ([vc.parentViewController isKindOfClass:[UINavigationController class]]) {
             self.frame=vc.parentViewController.view.bounds;
            [vc.parentViewController.view addSubview:self];
        }
    }
    [self destinationlayout];
    
}
-(void)setCorneradius:(CGFloat)_corneradius//设置其角度
{
    if (_corneradius<20.0) {
        _contentV.layer.masksToBounds = YES;
        _contentV.layer.cornerRadius = _corneradius;
//        [_contentV setViewRadius:_corneradius];
    }
}
-(void)initlayoutFrame
{
    if (_sendType==CSSendNoticeTypePicture) {
        _contentV.frame=CGRectMake(leftMargin,kCSScreenHeight, kCSScreenWidth-leftMargin*2, 190.0);
    }else{
        _contentV.frame=CGRectMake(leftMargin,kCSScreenHeight, kCSScreenWidth-leftMargin*2, 170.0);
    }
    _cancelBtn.frame=CGRectMake(10.0, 0.0, 30.0, 40.0);
    _titleLb.frame=CGRectMake(( _contentV.frameWidth-80.0)/2.0, 0.0, 80.0, 40.0);
    _submitBtn.frame=CGRectMake( _contentV.frameWidth-40.0, 0.0, 30.0, 40.0);
    _textV.frame= CGRectMake(10.0,40.0,_contentV.frameWidth-20.0, 110);
     self.counterLabel.frame=CGRectMake(_textV.frame.origin.x+_textV.frame.size.width-35, _textV.frame.origin.y+_textV.frame.size.height-20, 30, 15);
    if (_sendType==CSSendNoticeTypePicture) {
        _cameraBtn.frame=CGRectMake(_contentV.frameWidth-88, _contentV.frameHeight-35.0, 25.0, 30.0);
        _chooseBtn.frame=CGRectMake(_contentV.frameWidth-35, _contentV.frameHeight-35.0, 25.0, 30.0);
        
        showV.frame=CGRectMake(10.0,_contentV.frameHeight-35.0, _contentV.frameWidth-120.0, 30.0);
    }
}
-(void)resetContentVFrame
{
    if (_sendType==CSSendNoticeTypePicture) {
        _contentV.frame=CGRectMake(leftMargin,(kCSScreenHeight-190.0)/2.0, kCSScreenWidth-leftMargin*2, 190.0);
    }else{
        _contentV.frame=CGRectMake(leftMargin, (kCSScreenHeight-170.0)/2.0, kCSScreenWidth-leftMargin*2, 170.0);
    }
}

-(void)destinationlayout
{
    [self initlayoutFrame];
    [_textV becomeFirstResponder];
//    [UIView animateWithDuration:0.2 animations:^{
//        [self resetContentVFrame];
//    }];
}

-(void)keyWillShow:(NSNotification *)notification//显示键盘
{
    NSValue *nsValue=[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect=[nsValue CGRectValue];
    [UIView animateWithDuration:0.4 animations:^{
        if (_sendType==CSSendNoticeTypePicture) {
            _contentV.frame=CGRectMake(leftMargin, rect.origin.y-190.0, kCSScreenWidth-leftMargin*2, 190.0);
        }else{
            _contentV.frame=CGRectMake(leftMargin, rect.origin.y-170.0, kCSScreenWidth-leftMargin*2, 170.0);
        }
        
    }];
}
-(void)keyWillHiden:(NSNotification *)notification//关闭键盘
{
    [UIView animateWithDuration:0.4 animations:^{
        [self resetContentVFrame];
    }];
}

-(IBAction)takenPhoto:(id)sender
{
    if (self.imgs.count >= 9) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多只能发送九张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController* imgPicker=[[UIImagePickerController alloc] init];
            imgPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            imgPicker.delegate=self;
            CSViewController* controller=(CSViewController *)_delegate;
            [controller presentViewController:imgPicker animated:YES completion:^{}];
        }else{
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"不能使用相机功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
-(IBAction)choosePic:(id)sender
{
    if (self.imgs.count >= 9) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多只能发送九张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            NSInteger count = 9 - self.imgs.count;
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc]initWithMaxImagesCount:count delegate:nil];
            imagePickerVc.delegate = self;
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets) {
                NSMutableArray *imageCount = [NSMutableArray array];
                NSInteger remainCount = 9 - imgs.count;
                if (remainCount >= photos.count) {
                    [imageCount addObjectsFromArray:photos];
                    [imgs addObjectsFromArray:imageCount];
                }else{
                    [imageCount addObjectsFromArray:[photos subarrayWithRange:NSMakeRange(0, remainCount)]];
                    [imgs addObjectsFromArray:photos];
                }
                for (UIImage *image in imageCount) {
                    [showV addImage:image];
                }
            }];
            
            CSViewController* controller=(CSViewController *)_delegate;
            [controller presentViewController:imagePickerVc animated:YES completion:^{}];
        }else{
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"不能访问像册功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }

    }
    
}
#pragma mark--
#pragma mark-UITextViewDelegate
//- (void)textViewDidChange:(UITextView *)textView
//{
//    if (textView.text.length>0) {
//        _placeholderLb.hidden=YES;
//    }else{
//        _placeholderLb.hidden=NO;
//    }
//}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}


#pragma mark--
#pragma mark--UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSMutableArray *arr = [NSMutableArray array];
    [arr addObject:info[UIImagePickerControllerOriginalImage]];
    [imgs addObjectsFromArray:arr];
    [picker dismissViewControllerAnimated:YES completion:^{
        for (UIImage *image in arr) {
            [showV addImage:image];
        }
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}
#pragma mark--
#pragma mark--CSShowViewDelegate
-(void)resginFirstResponse
{
    [_textV resignFirstResponder];
}

-(void)removeImg:(UIImage *)img
{
    [imgs removeObject:img];
}

#pragma mark-sendImage-method    
-(void)sendImage:(UIImage *)image
{

    UIImage* newImage=[[image fitSmallImage:CGSizeMake(kCSScreenWidth*2, kCSScreenHeight*2)] fixOrientation];
    NSData* data=UIImageJPEGRepresentation(newImage, 0.4);
    UIImage* anotherImg=[UIImage imageWithData:data];
    if ([imgs count]>=9) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"最多只能发送九张图片" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [imgs addObject:anotherImg];
        [showV addImage:anotherImg];
    }
    
}

@end
