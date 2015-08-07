//
//  NSMutableDictionary+Utility.h
//  QunariPhone
//
//  Created by Neo on 3/8/13.
//  Copyright (c) 2013 Qunar.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Utility)

- (void)setObjectSafe:(id)anObject forKey:(id < NSCopying >)aKey;

- (NSString *) md5;

@end
