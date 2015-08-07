//
//  NetworkAPI.m
//  byy
//
//  Created by fengshaobo on 14-4-1.
//  Copyright (c) 2014年 byy. All rights reserved.
//

#import "NetworkAPI.h"
#import "NetworkRespond.h"

#define kHostName @"http://1.quickjudge.sinaapp.com"


@interface NetworkAPI ()

// 保存请求信息
@property (nonatomic, strong) NSMutableDictionary *requestDict;

@end


@implementation NetworkAPI

SYNTHESIZE_SINGLETON(NetworkAPI)

- (id)init
{
    self = [super init];
    if (self) {
        self.requestDict = [NSMutableDictionary dictionary];
    }
    return self;
}


- (void) singletonDealloc
{
    self.requestDict = nil;
}

- (void)apiGet:(NSString *)keyword withParam:(NSDictionary *)param respondData:(id)data result:(SAPIBlock)block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //添加auth_token
    NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    if ([auth_token length] > 0) {
        [dict setObjectSafe:auth_token forKey:@"auth_token"];
    }

    if (param) {
        [dict addEntriesFromDictionary:param];
    }
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kHostName,keyword];
    
    SLog(@" \n ==== request urlStr ==== \n%@\n \n", urlStr);
    SLog(@" \n ==== dict ==== \n%@\n \n",dict);
    
    //发出请求
    AFHTTPRequestOperation * opeartion =
    [manager GET:urlStr
      parameters:dict
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [data parseAllNetResult:responseObject forInfo:nil];
             
             SLog(@" \n ==== responseObject ==== \n%@\n \n",responseObject);
             SLog(@" \n ==== result ==== \n%@\n \n",data);

              if (block) {
                  block(ESuccess, data, operation);
              }
             
          }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              if (block) {
                  block(EFailure, nil, operation);
              }
              
    }];
    
    if (opeartion) {

        if (block) {
            block(ELoading, nil, opeartion);
        }
        
    }
    else {
        
        if (block) {
            block(EFailure, nil, nil);
        }
        
    }
    
}


- (void)apiPost:(NSString *)keyword withParam:(NSDictionary *)param respondData:(id)data result:(SAPIBlock)block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
     NSString *urlStr = [NSString stringWithFormat:@"%@%@",kHostName,keyword];
    
    //添加auth_token
    NSString *auth_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"auth_token"];
    if ([auth_token length] > 0) {
        [dict setObjectSafe:auth_token forKey:@"auth_token"];
    }
    
    
    if (param) {
        [dict addEntriesFromDictionary:param];
    }
    
   
   //
    SLog(@" ==== request urlStr : %@", urlStr);
    SLog(@" ==== dict : %@",dict);

    //发出请求
    AFHTTPRequestOperation * opeartion =
    [manager POST:urlStr
       parameters:dict
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
             [data parseAllNetResult:responseObject forInfo:nil];
             
             if (block) {
                 block(ESuccess, data, operation);
             }
             
         }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             if (block) {
                 block(EFailure, nil, operation);
             }
             
         }];
    
    if (opeartion) {
        
        if (block) {
            block(ELoading, nil, opeartion);
        }
        
    }
    else {
        
        if (block) {
            block(EFailure, nil, nil);
        }
        
    }
    
}


- (void)apiUploadImage:(NSString *)imagePath respondData:(id)data result:(SAPIBlock)block
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",kHostName,@"/image/upload/"];
    
    SLog(@" ==== request urlStr : %@", urlStr);
    
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    NSURL *filePath = [NSURL fileURLWithPath:imagePath];
    //发出请求
    AFHTTPRequestOperation * opeartion =
    [manager POST:urlStr
       parameters:dict
constructingBodyWithBlock: ^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileURL:filePath name:@"image" error:nil];
       }
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              
              [data parseAllNetResult:responseObject forInfo:nil];
              
              if (block) {
                  block(ESuccess, data, operation);
              }
              
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              
              if (block) {
                  block(EFailure, nil, operation);
              }
              
          }];
    
    if (opeartion) {
        
        if (block) {
            block(ELoading, nil, opeartion);
        }
        
    }
    else {
        
        if (block) {
            block(EFailure, nil, nil);
        }
        
    }
    
}


#pragma mark - 当前网络状态

+ (NETWORK_TYPE)networkType
{
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
    NSNumber *dataNetworkItemView = nil;
    
    for (id subview in subviews) {
        
        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]])     {
            dataNetworkItemView = subview;
            break;
        }
    }
    
    NETWORK_TYPE nettype = NETWORK_TYPE_NONE;
    NSNumber * num = [dataNetworkItemView valueForKey:@"dataNetworkType"];
    nettype = [num intValue];
    
    return nettype;
}

@end
