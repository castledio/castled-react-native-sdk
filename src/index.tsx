import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The package 'castled-react-native-sdk' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

// @ts-expect-error
const isTurboModuleEnabled = global.__turboModuleProxy != null;

const CastledReactNativeModule = isTurboModuleEnabled
  ? require('./NativeCastledReactNativeSdk').default
  : NativeModules.NativeCastledReactNativeSdk;

const CastledReactNativeSdk = CastledReactNativeModule
  ? CastledReactNativeModule
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function multiply(a: number, b: number): Promise<number> {
  // CastledReactNativeSdk.initialize({ key: 'test' });
  return new Promise((resolve, reject) => {
    resolve(CastledReactNativeSdk.multiply(12, 5));
  });
}
