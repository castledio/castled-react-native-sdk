import { NativeModules, Platform, NativeEventEmitter } from 'react-native';
import { CastledConfigs, CastledPushTokenType } from './CastledConfigs';
import CastledUserAttributes from './CastledUserAttributes';
import type { CastledEventParams } from './types/CastledEventParams';

const LINKING_ERROR =
  `The package 'castled-react-native-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const CastledReactNativeModule = isTurboModuleEnabled
  ? require('./NativeCastledNotifications').default
  : NativeModules.RTNCastledNotifications;

const CastledReactNativeInstance = CastledReactNativeModule
  ? CastledReactNativeModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

class CastledNotifications {
  // static eventEmitter = new NativeEventEmitter(CastledReactNativeModule);
  static eventEmitter: NativeEventEmitter = new NativeEventEmitter(
    CastledReactNativeModule
  );

  static initialize(configs: CastledConfigs): void {
    CastledReactNativeInstance.initialize(configs);
  }

  static setUserId(userId: string, userToken?: string): void {
    CastledReactNativeInstance.setUserId(userId, userToken);
  }

  static logout(): void {
    CastledReactNativeInstance.logout();
  }

  static setPushToken(
    token: string,
    pushTokenType?: CastledPushTokenType
  ): void {
    if (Platform.OS === 'ios') {
      CastledReactNativeInstance.onTokenFetch(token);
    } else {
      if (!pushTokenType) {
        pushTokenType = CastledPushTokenType.FCM;
      }
      CastledReactNativeInstance.onTokenFetch(token, pushTokenType);
    }
  }

  static logEvent(eventName: string, eventParams?: CastledEventParams): void {
    CastledReactNativeInstance.logCustomAppEvent(eventName, eventParams);
  }

  static setUserAttributes(attrs: CastledUserAttributes): void {
    CastledReactNativeInstance.setUserAttributes(attrs);
  }

  static addListener(
    event: string,
    subscriber: { (event: Object): void; (event: any): void }
  ) {
    return CastledNotifications.eventEmitter.addListener(event, subscriber);
  }
}

export { CastledNotifications };
