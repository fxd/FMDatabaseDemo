//
//  SignletonTemplate.h
//  sight_iphone
//
//  Created by fengshaobo on 14-4-1.
//  Copyright (c) 2014年 Qunar.com. All rights reserved.
//


//============================
#undef DECLARE_SINGLETON
#define DECLARE_SINGLETON(classname) \
+ (classname *)sharedInstance;\
+ (void)cleanUp;

//============================
#undef SYNTHESIZE_SINGLETON

//- (id)init \
//{ \
//    if (Shared##classname == nil) { \
//        self = [super init]; \
//        if (self && [self respondsToSelector:@selector(singletonInit)]) { \
//            [self singletonInit]; \
//        } \
//        return self; \
//    } \
//    return Shared##classname; \
//}\
//\

#if __has_feature(objc_arc) //ARC Version
#define SYNTHESIZE_SINGLETON(classname)   \
\
static classname __strong *Shared##classname = nil; \
\
+ (classname *)sharedInstance \
{\
    if (Shared##classname == nil) {\
        static dispatch_once_t onceToken;\
        dispatch_once(&onceToken, ^{\
            Shared##classname = [[classname alloc] init];\
        });\
    }\
    return Shared##classname;\
} \
+ (void)cleanUp \
{ \
    Shared##classname = nil; \
}


#else // Non-ARC Version

#define SYNTHESIZE_SINGLETON(classname) \
\
static classname *Shared##classname = nil; \
\
+ (classname *)sharedInstance \
{ \
    @synchronized(self) { \
        if (Shared##classname == nil) { \
            Shared##classname = [[self alloc] init]; \
        } \
    } \
    return Shared##classname; \
} \
\
+ (void)cleanUp { \
    [Shared##classname dealloc]; \
    Shared##classname = nil; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
    @synchronized(self) { \
        if (Shared##classname == nil) { \
            Shared##classname = [super allocWithZone:zone]; \
            return Shared##classname; \
        } \
    } \
    return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
    return self; \
} \
\
- (id)retain \
{ \
    return self; \
} \
\
- (NSUInteger)retainCount \
{ \
    return NSUIntegerMax; \
} \
\
- (oneway void)release \
{ \
} \
\
- (id)autorelease \
{ \
    return self; \
}
#endif
