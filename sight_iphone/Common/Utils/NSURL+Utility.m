//
//  NSURL+XQueryComponents.m
//  QunarIphone
//
//  Created by 姜琢 on 12-11-6.
//
//

#import "NSURL+Utility.h"
#import "NSString+Utility.h"

@implementation NSURL (Utility)

- (NSDictionary *)queryComponents
{
    return [[self query] dictionaryFromQueryComponents];
}

@end
