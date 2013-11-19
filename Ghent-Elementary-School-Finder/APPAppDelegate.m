//
//  APPAppDelegate.m
//  Ghent-Elementary-School-Finder
//
//  Created by Jarno Verreyt on 15/11/13.
//  Copyright (c) 2013 Appreciate. All rights reserved.
//

#import "APPAppDelegate.h"

@implementation APPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSString *searchNetwork = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchNetwork"];
    if (searchNetwork == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Katholiek onderwijs" forKey:@"searchNetwork"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    APPHomeViewController *homeVC = [[APPHomeViewController alloc] initWithNibName:nil bundle:nil];
    self.navController = [[APPNavViewController alloc] initWithRootViewController:homeVC];
    
    self.window.rootViewController = self.navController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
@end
