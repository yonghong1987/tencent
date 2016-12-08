//
//  XHMessageTextView+XHMessageValidation.h
//  sunMobile
//
//  Created by duck on 16/8/29.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "XHMessageTextView.h"

@interface XHMessageTextView (XHMessageValidation)

- (BOOL)validWithError:(NSString *)mesg;

- (void)setMaxLenth:(NSUInteger)maxLenth withErrorMesg:(NSString *)mesg;

@end
