import type { TurboModule } from 'react-native';
import { TurboModuleRegistry } from 'react-native';

export interface Spec extends TurboModule {
  initialize(configs: Object): void;

  setUserId(userId: string, userToken?: string): void;

  logout(): void;

  onTokenFetch(token: string, pushTokenType: string): void;

  logCustomAppEvent(eventName: string, eventParams?: Object): void;

  setUserAttributes(attributes: Object): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>(
  'RTNCastledNotifications'
);