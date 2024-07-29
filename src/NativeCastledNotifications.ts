import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  initialize(configs: Object): void;

  setUserId(userId: string, userToken?: string): void;

  logout(): void;

  onTokenFetch(token: string, pushTokenType: string): void;

  logCustomAppEvent(eventName: string, eventParams?: Object): void;

  logPageViewedEvent(screenName: string): void;

  stopInApp(): void;

  resumeInApp(): void;

  pauseInApp(): void;

  setUserAttributes(attributes: Object): void;

  requestPushPermission(): Promise<boolean>;

  getPushPermission(): Promise<boolean>;

  // NativeEventEmitter methods for the New Architecture.
  // The implementations are handled implicitly by React Native.
  addListener: (eventType: string) => void;

  removeListeners: (count: number) => void;

  showAppInbox(configs?: Object): void;

  getInboxUnreadCount(): Promise<number>;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'RTNCastledNotifications'
);
