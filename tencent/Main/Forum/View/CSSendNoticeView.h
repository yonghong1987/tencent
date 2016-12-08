//
//  CSSendNoticeView.h
//  eLearning
//
//  Created by sunon on 14-5-7.
//  Copyright (c) 2014年 sunon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CSShowView.h"

typedef NS_ENUM(NSInteger, CSSendNoticeType) {
    CSSendNoticeStyleDefault = 0,//默认
    CSSendNoticeTypePicture  //显示照相按钮
};
@class CSSendNoticeView;
@protocol CSSendNoticeDelegate<NSObject>
@optional
-(void)alertNotificeView:(CSSendNoticeView *)alertView clickButtonAtIndex:(NSInteger)index params:(NSMutableDictionary *)dict;
@end
@interface CSSendNoticeView : UIView<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CSShowViewDelegate,UITextViewDelegate>
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign)CGFloat leftMargin;
@property(nonatomic,assign)CGFloat corneradius;
-(id)initWithTitle:(NSString *)title delegate:(id)delegate leftBtnTitle:(NSString *)leftTitle rightBtnTitle:(NSString *)rightTitle csSendType:(CSSendNoticeType)type;
-(id)initWithTitle:(NSString *)title delegate:(id)delegate leftBtnImage:(UIImage *)leftImg rightBtnImage:(UIImage *)rightImg csSendType:(CSSendNoticeType)type;
-(void)show;
@end
