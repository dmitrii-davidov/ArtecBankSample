//
//  ANAppDelegate.m
//  ArtecBankSample
//
//  Created by Dmitry Davidov on 09.06.14.
//  Copyright (c) 2014 Anabatik. All rights reserved.
//

#import "ANAppDelegate.h"


NSString *const kANAppDelegateFetchBanksURLString = @"https://qbank.ru:3015/MobileBankServer/AdvertisementService.svc/Query";


@implementation ANAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    return YES;
}

+ (NSURLRequest *)fetchBankDepartmentsFromServerURLRequest
{
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kANAppDelegateFetchBanksURLString]];
    [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    urlRequest.HTTPMethod = @"POST";
    urlRequest.HTTPBody = ({
        NSDictionary *requestBodyObject = @{@"type": @2,
                                            @"position": @{@"lat": @55.708337,
                                                           @"lng": @37.651938999999999,},
                                            @"onlyIds": @NO,
                                            @"providerFilter": @[@0, @1],
                                            @"skip": @0,
                                            @"top": @50,
                                            @"typeFilter": @[@2],
                                            @"radius": @{@"min": @0,
                                                         @"max": @500},};
        NSError *error = nil;
        NSData *requestBodyData = [NSJSONSerialization dataWithJSONObject:requestBodyObject options:NSJSONWritingPrettyPrinted error:&error];
#ifdef DEBUG
        NSString *requestBodyString = [[NSString alloc] initWithData:requestBodyData encoding:NSUTF8StringEncoding];
        NSLog(@"fetch bank departments url request body:\n%@", requestBodyString);
#endif
        requestBodyData;
    });

    return urlRequest;
}

@end
