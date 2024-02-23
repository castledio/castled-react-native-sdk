import * as React from 'react';

import {
  StyleSheet,
  View,
  Text,
  Button,
  SafeAreaView,
  Alert,
} from 'react-native';
import {
  CastledNotifications,
  CastledConfigs,
  CastledLocation,
  CastledLogLevel,
  CastledUserAttributes,
  CastledEvents,
  type CastledClickAction,
  type CastledPushNotification,
  type CastledPushNotificationClickEvent,
} from 'castled-react-native-sdk';

import Header from './Header';

const Separator = () => <View style={styles.separator} />;

const configs = new CastledConfigs();
configs.appId = 'e8a4f68bfb6a58b40a77a0e6150eca0b';
configs.location = CastledLocation.TEST;
configs.enableInApp = true;
configs.enablePushBoost = true;
// configs.enableSessionTracking = true;
configs.enablePush = true;
configs.inAppFetchIntervalSec = 300;
configs.sessionTimeOutSec = 10;
configs.skipUrlHandling = true;
configs.appgroupId = '';
configs.logLevel = CastledLogLevel.DEBUG;

const userAttrs = new CastledUserAttributes();
userAttrs.setFirstName('antony');
userAttrs.setLastName('mathew');
userAttrs.setPhone('+919496371536');
userAttrs.setCustomAttribute('ios_rn-custom-1', 100);
userAttrs.setCustomAttribute('ios_rn-custom-2', true);
userAttrs.setCustomAttribute('ios_rn-custom-3', 'string');

export default function App() {
  const testData = {
    user: 'antony@castled.io',
    event: 'rn_test_event_2',
    params: {
      str: 'ios_val1',
      num: 20,
      bool: false,
    },
  };

  const pushClickedListener = CastledNotifications.addListener(
    CastledEvents.PUSH_NOTIFICATION_CLICKED,
    (event: CastledPushNotificationClickEvent) => {
      setTimeout(() => {
        // Code to be executed after the delay
        Alert.alert(
          'Castled push notification clicked!',
          event.notification.title
        );
      }, 1000);

      console.log(
        'Push notification clicked: notification object ',
        event.notification
      );
      console.log('Push notification clicked: clickAction', event.clickAction);
    }
  );

  const pushReceivedListener = CastledNotifications.addListener(
    CastledEvents.PUSH_NOTIFICATION_RECEIVED,
    (notification: CastledPushNotification) => {
      console.log('Push notification received:', notification);
    }
  );
  const pushDismissedListener = CastledNotifications.addListener(
    CastledEvents.PUSH_NOTIFICATION_DISMISSED,
    (notification: CastledPushNotification) => {
      console.log('Push notification dismissed:', notification);
    }
  );
  const inAppClickedListener = CastledNotifications.addListener(
    CastledEvents.IN_APP_MESSAGE_CLICKED,
    (inappClickEvent: CastledClickAction) => {
      console.log('Inapp clicked:', inappClickEvent);
    }
  );

  React.useEffect(() => {
    CastledNotifications.initialize(configs);
    CastledNotifications.requestPushPermission();

    // Return cleanup function
    return () => {
      // Cleanup tasks (unsubscribe from subscriptions, remove event listeners, etc.)
      pushClickedListener.remove();
      pushReceivedListener.remove();
      pushDismissedListener.remove();
      inAppClickedListener.remove();
    };
  }, [
    pushClickedListener,
    pushReceivedListener,
    pushDismissedListener,
    inAppClickedListener,
  ]);

  return (
    <SafeAreaView style={styles.container}>
      <Header title={'Castled React SDK Test'}></Header>
      <View style={styles.container}>
        <Text style={styles.title}>Testing user identification</Text>
        <Button
          title="Identify"
          onPress={() => CastledNotifications.setUserId(testData.user)}
        />
        <Separator />
        <Text style={styles.title}>Testing event tracking</Text>
        <Button
          title="Log Event"
          onPress={() =>
            CastledNotifications.logEvent(testData.event, testData.params)
          }
        />
        <Separator />
        <Text style={styles.title}>Testing user attributes tracking</Text>
        <Button
          title="Log User Attributes"
          onPress={() => {
            CastledNotifications.setUserAttributes(userAttrs);
          }}
        />
        <Separator />
        <Text style={styles.title}>Testing logout</Text>
        <Button title="Logout" onPress={() => CastledNotifications.logout()} />
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    marginHorizontal: 16,
    backgroundColor: '#dadada',
  },
  title: {
    textAlign: 'center',
    marginVertical: 8,
  },
  fixToText: {
    flexDirection: 'row',
    justifyContent: 'space-between',
  },
  separator: {
    marginVertical: 8,
    borderBottomColor: '#737373',
    borderBottomWidth: StyleSheet.hairlineWidth,
  },
});
