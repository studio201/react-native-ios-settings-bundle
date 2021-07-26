
#import "RNIosSettingsBundle.h"
#import <React/RCTLog.h>

@implementation RNIosSettingsBundle

- (dispatch_queue_t)methodQueue
{
    return dispatch_get_main_queue();
}
RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getValByKey:(NSString *)key  callback:(RCTResponseSenderBlock)callback)
{
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }

    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if([defaults objectForKey:key] == nil){
        NSString *result = [NSString stringWithFormat:@"value  is empty or the key %@ is not defined!!%@!!", key, [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]];
        callback(@[ @[ @true , result] , [NSNull null]]);
    }

    else
        callback(@[[NSNull null], [defaults objectForKey:key]]);
}

@end
