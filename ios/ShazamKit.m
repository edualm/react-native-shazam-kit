#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ShazamKit, NSObject)

RCT_EXTERN_METHOD(isSupported:(NSString *)empty
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(listen:(NSString *)empty
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

RCT_EXTERN_METHOD(stop:(NSString *)empty
                  withResolver:(RCTPromiseResolveBlock)resolve
                  withRejecter:(RCTPromiseRejectBlock)reject)

@end
