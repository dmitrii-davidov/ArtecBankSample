//
//  ANAppDelegate.h
//  ArtecBankSample
//
//  Created by Dmitry Davidov on 09.06.14.
//  Copyright (c) 2014 Anabatik. All rights reserved.
//


@interface ANAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (NSURLRequest *)fetchBankDepartmentsFromServerURLRequest;

@end
