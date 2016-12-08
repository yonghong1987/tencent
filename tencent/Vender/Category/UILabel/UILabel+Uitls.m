//
//  UILabel+Uitls.m
//  sunMobile
//
//  Created by duck on 16/7/1.
//  Copyright © 2016年 www.sunontalent.com. All rights reserved.
//

#import "UILabel+Uitls.h"

@implementation UILabel (Uitls)


-(void)setLocalString:(NSString *)localString{
    self.text = NSLocalizedString(localString, nil);
}

- (NSString *)localString{
    return self.text;
}
@end
