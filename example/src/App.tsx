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
} from 'castled-react-native-sdk';

import Header from './Header';

const Separator = () => <View style={styles.separator} />;

const configs = new CastledConfigs();
configs.appId = '718c38e2e359d94367a2e0d35e1fd4df';
configs.enableTracking = true;
configs.location = CastledLocation.US;
configs.enableInApp = true;
configs.enablePushBoost = true;
configs.enablePush = true;
configs.inAppFetchIntervalSec = 300;
configs.appgroupId = '';
configs.logLevel = CastledLogLevel.DEBUG;

export default function App() {
  const testData = {
    user: 'antony@castled.io',
    event: 'rn_test_event_2',
    params: {
      str: 'val1',
      num: 10,
      bool: true,
    },
  };

  /* const pushClickedListener = CastledNotifications.addListener(
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
        'Push notification clicked: clickAction',
        event.clickAction?.keyVals
      );
      console.log(
        'Push notification clicked: notification object ',
        event.notification
      );
    }
  );

  const pushReceivedListener = CastledNotifications.addListener(
    CastledEvents.PUSH_NOTIFICATION_RECEIVED,
    (notification: CastledPushNotification) => {
      console.log('Push notification received:', notification);
    }
  );

  const inAppClickedListener = CastledNotifications.addListener(
    CastledEvents.IN_APP_MESSAGE_CLICKED,
    (inappClickEvent: CastledClickAction) => {
      console.log('Inapp clicked:', inappClickEvent.keyVals);
    }
  );*/

  React.useEffect(() => {
    CastledNotifications.initialize(configs);
    CastledNotifications.requestPushPermission();

    return () => {
      // pushClickedListener.remove();
      // pushReceivedListener.remove();
      // inAppClickedListener.remove();
    };
  }, []);

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
          onPress={() => Alert.alert('Not Implemented!')}
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
