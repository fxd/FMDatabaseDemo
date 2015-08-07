//
//  NSObject+Utility.m
//  QunariPhone
//
//  Created by Neo on 11/29/12.
//  Copyright (c) 2012 Qunar.com. All rights reserved.
//

#import "NSObject+Utility.h"
#import <Foundation/NSObjCRuntime.h>
#import <objc/runtime.h>
#import "SearchNetResult.h"
#import "NetworkParseMapper.h"

@implementation NSObject (Utility)

// 成员变量转换成字典
- (void)serializeSimpleObject:(NSMutableDictionary *)dictionary
{
    NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
    // 获取property
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++)
    {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        
		// 获取对象
        Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
		if(iVar == nil)
		{
			// 采用另外一种方法尝试获取
			iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
		}
		
		// 赋值
		if(iVar != nil)
		{
			id propertyValue = object_getIvar(self, iVar);
			
			// 插入Dictionary中
			if(propertyValue != nil)
			{
				[dictionary setObject:propertyValue forKey:propertyName];
			}
		}
    }
	
    free(properties);
}

// 自动解析Json
- (void)parseJsonAutomatic:(NSDictionary *)dictionaryJson forInfo:(id)customInfo
{
	// 如果Json数据无效,产生Sentry Json
	if(dictionaryJson == nil)
	{
		dictionaryJson = [[NSDictionary alloc] init];
	}
	
	// 获取对象
	NSString *className = NSStringFromClass([self class]);
    const char *cClassName = [className UTF8String];
    id theClass = objc_getClass(cClassName);
    
	// 获取property
    unsigned int propertyCount;
    objc_property_t *properties = class_copyPropertyList(theClass, &propertyCount);
    for(unsigned int i = 0; i < propertyCount; i++)
    {
		// 获取Var
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
		Ivar iVar = class_getInstanceVariable([self class], [propertyName UTF8String]);
		if(iVar == nil)
		{
			// 采用另外一种方法尝试获取
			iVar = class_getInstanceVariable([self class], [[NSString stringWithFormat:@"_%@", propertyName] UTF8String]);
		}
		
		// 获取Name
		if((iVar != nil) && (![dictionaryJson isEqual:[NSNull null]]))
		{
			// 通过propertyName去Json中寻找Value
			id jsonValue = [dictionaryJson objectForKey:propertyName];
			
			// dictionary对象
			if(([jsonValue isKindOfClass:[NSDictionary class]]) || ([jsonValue isKindOfClass:[NSMutableDictionary class]]))
			{
				// 获取数据类型
				NSString *varType = [NetworkParseMapper getVarTypeByVar:propertyName fromClass:className];
				if(varType != nil)
				{
					// 创建对象
					Class varClass = NSClassFromString(varType);
					id varObject = [[varClass alloc] init];
					
					// 进行自定义解析
					if((varObject != nil) && ([varObject respondsToSelector:@selector(parseNetResult:forInfo:)]))
					{
						[varObject parseNetResult:jsonValue forInfo:customInfo];
					}
					// 递归进行下层解析
					else
					{
						[varObject parseJsonAutomatic:jsonValue forInfo:customInfo];
					}
					
					// 赋值
					object_setIvar(self, iVar, varObject);
                }
                // 其他的对象(直接赋值,!!!!!如果还有dictionary,array之类的其他特殊对象，继续在上面补充!!!!!)
                else
                {
                    // 赋值
                    object_setIvar(self, iVar, jsonValue);
                }
			}
			// array对象
			else if([jsonValue isKindOfClass:[NSArray class]] || ([jsonValue isKindOfClass:[NSMutableArray class]]))
			{
				// 获取数据类型
				NSString *varType = [NetworkParseMapper getVarTypeByVar:propertyName fromClass:className];
				if(varType != nil)
				{
					NSMutableArray *arrayDest = [[NSMutableArray alloc] init];
					
					// 基本数据类型
					if(([varType isEqualToString:@"NSString"]) || ([varType isEqualToString:@"NSNumber"]))
					{
						[arrayDest addObjectsFromArray:jsonValue];
					}
					else
					{
						Class varClass = NSClassFromString(varType);
						
						// 解析
						NSInteger jsonCount = [jsonValue count];
						for(NSInteger i = 0; i < jsonCount; i++)
						{
							id item = [jsonValue objectAtIndex:i];
                            
                            if ([item isKindOfClass:[NSDictionary class]])
                            {
                                NSDictionary *dictionaryJsonItem = item;
                                if(dictionaryJsonItem != nil)
                                {
                                    id varObject = [[varClass alloc] init];
                                    
                                    // 进行自定义解析
                                    if((varObject != nil) && ([varObject respondsToSelector:@selector(parseNetResult:forInfo:)]))
                                    {
                                        [varObject parseNetResult:dictionaryJsonItem forInfo:customInfo];
                                    }
                                    // 递归进行下层解析
                                    else
                                    {
                                        [varObject parseJsonAutomatic:dictionaryJsonItem forInfo:customInfo];
                                    }
                                    
                                    [arrayDest addObject:varObject];
                                }
                            }
                            else if ([item isKindOfClass:[NSArray class]])
                            {
                                NSArray *arrayJsonItem = item;
                                if(arrayJsonItem != nil)
                                {
                                    id varObject = [[varClass alloc] init];
                                    
                                    // 进行自定义解析
                                    if((varObject != nil) && ([varObject respondsToSelector:@selector(parseNetResult:forInfo:)]))
                                    {
//                                        [varObject parseNetResult:arrayJsonItem forInfo:customInfo];
                                    }
                                    // 递归进行下层解析
                                    else
                                    {
                                        varObject = [NSObject parseJsonArrayAutomatic:item
                                                                      withObjectClass:varClass
                                                                              forInfo:customInfo];
                                    }
                                    
                                    [arrayDest addObject:varObject];
                                }
                            }
						}
					}
					
					// 赋值
					object_setIvar(self, iVar, arrayDest);
                }
                // 其他的对象(直接赋值,!!!!!如果还有dictionary,array之类的其他特殊对象，继续在上面补充!!!!!)
                else
                {
                    // 赋值
                    object_setIvar(self, iVar, jsonValue);
                }
			}
			else if ([jsonValue isKindOfClass:[NSNull class]])
			{
				// 空对象，不进行处理，让对象继续保持为nil
			}
			// 其他的对象(直接赋值,!!!!!如果还有dictionary,array之类的其他特殊对象，继续在上面补充!!!!!)
			else
			{
				// 赋值
				object_setIvar(self, iVar, jsonValue);
			}
		}
    }

    free(properties);
}

// 自动解析JsonArray
+ (NSArray *)parseJsonArrayAutomatic:(NSArray *)arrayJson withObjectClass:(Class)objectClass forInfo:(id)customInfo
{
	// 如果Json数据无效,产生Sentry Json
	if(arrayJson == nil)
	{
		arrayJson = [[NSArray alloc] init];
	}
	
	NSMutableArray *arrayDest = [[NSMutableArray alloc] init];
	
	const char *cClassName = class_getName(objectClass);
	NSString *className = [NSString stringWithUTF8String:cClassName];
	
	// 基本数据类型
	if(([className isEqualToString:@"NSString"]) || ([className isEqualToString:@"NSNumber"]))
	{
		[arrayDest addObjectsFromArray:arrayJson];
	}
	else
	{
		// 解析
		NSInteger jsonCount = [arrayJson count];
		for(NSInteger i = 0; i < jsonCount; i++)
		{
			NSDictionary *dictionaryJson = [arrayJson objectAtIndex:i];
			if(dictionaryJson != nil)
			{
				id varObject = [[objectClass alloc] init];
				
				// 进行自定义解析
				if((varObject != nil) && ([varObject respondsToSelector:@selector(parseNetResult:forInfo:)]))
				{
					[varObject parseNetResult:dictionaryJson forInfo:customInfo];
				}
				// 递归进行下层解析
				else
				{
					[varObject parseJsonAutomatic:dictionaryJson forInfo:customInfo];
				}
				
				[arrayDest addObject:varObject];
			}
		}
	}
	
	return arrayDest;
}

@end
