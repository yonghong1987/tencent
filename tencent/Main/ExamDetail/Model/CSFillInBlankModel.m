//
//  CSFillInBlankModel.m
//  tencent
//
//  Created by bill on 16/5/20.
//  Copyright © 2016年 cyh. All rights reserved.
//

#import "CSFillInBlankModel.h"

/*       *********** 选项答案相关信息 **************** */
@implementation CSChoiceOptionTitleModel

@end
/*       *********** ************* **************** */


/*       *********** 选项具体信息 **************** */
@implementation CSChoiceOptionContentModel

@end
/*       *********** ************* **************** */


/*       *********** 试题信息 **************** */
@implementation CSFillInBlankModel

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err{
    self = [super initWithDictionary:dict error:err];
    
    self.choiceOptionDic = [NSMutableDictionary dictionary];
    
    id choiceOption = [dict objectForKey:@"choiceOption"];
    id choiceOptionList = [choiceOption objectForKey:@"choiceOptionList"];

    //选择答案
    id choiceAnswer = [choiceOption objectForKey:@"choiceAnswer"];
    choiceAnswer = choiceAnswer ? choiceAnswer : [NSArray array];
    [self.choiceOptionDic setValue:choiceAnswer forKey:@"choiceAnswer"];
 
    //选项内容
     if (  choiceOptionList ) {
         NSMutableArray *choiceOptionAry = [NSMutableArray array];
        for( id content in choiceOptionList ){
            CSChoiceOptionContentModel *current = [[CSChoiceOptionContentModel alloc] initWithDictionary:content error:nil];
            [choiceOptionAry addObject:current];
        }
        [self.choiceOptionDic setValue:choiceOptionAry forKey:@"choiceOptionList"];
    }
    
    return self;
}
@end
