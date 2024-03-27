#import "AppDelegate.h"
#import "WeCloudIMClient.h"
#import "GeneratedPluginRegistrant.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

    [[WeCloudIMClient sharedWeCloudIM] appDesk:application];
}


@end
