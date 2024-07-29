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
  CastledInboxConfigs,
} from 'castled-react-native-sdk';

import Header from './Header';

const Separator = () => <View style={styles.separator} />;

const configs = new CastledConfigs();
configs.appId = '718c38e2e359d94367a2e0d35e1fd4df';
configs.location = CastledLocation.US;
configs.enableInApp = true;
configs.enablePushBoost = true;
configs.enableTracking = true;
configs.enableAppInbox = true;
configs.enablePush = true;
configs.inAppFetchIntervalSec = 300;
configs.sessionTimeOutSec = 10;
configs.skipUrlHandling = false;
configs.appgroupId = '';
configs.logLevel = CastledLogLevel.DEBUG;

const userAttrs = new CastledUserAttributes();
userAttrs.setFirstName('antony');
userAttrs.setLastName('mathew');
userAttrs.setPhone('+919496371536');
userAttrs.setCustomAttribute('ios_rn-custom-1', 100);
userAttrs.setCustomAttribute('ios_rn-custom-2', true);
userAttrs.setCustomAttribute('ios_rn-custom-3', 'string');

const inboxConfigs = new CastledInboxConfigs();
inboxConfigs.emptyMessageViewText = 'No inbox items';
inboxConfigs.navigationBarTitle = 'React App Inbox';
inboxConfigs.emptyMessageViewTextColor = '#e5a46e';
inboxConfigs.navigationBarTitleColor = '#d1dddb';
inboxConfigs.inboxViewBackgroundColor = '#85b8cb';
inboxConfigs.navigationBarBackgroundColor = '#283b42';

inboxConfigs.tabBarSelectedBackgroundColor = '#D5B942';
inboxConfigs.tabBarDefaultBackgroundColor = '#edfbc1';
inboxConfigs.tabBarDefaultTextColor = '#fec0c1';
inboxConfigs.tabBarSelectedTextColor = '#fe5858';
inboxConfigs.tabBarIndicatorBackgroundColor = '#db5a9a';

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
    CastledEvents.IN_APP_CLICKED,
    (inappClickEvent: CastledClickAction) => {
      console.log('Inapp clicked.:', inappClickEvent);
    }
  );
  const inboxClickedListener = CastledNotifications.addListener(
    CastledEvents.INBOX_CLICKED,
    (inboxClickEvent: CastledClickAction) => {
      console.log('Inbox notification clicked:', inboxClickEvent);
    }
  );
  function promptForNotificationPermission() {
    CastledNotifications.requestPushPermission()
      .then((isGranted) => {
        if (isGranted) {
          console.log('Push notification permission granted');
        } else {
          console.log('Push notification permission denied');
        }
      })
      .catch((error) => {
        console.log('Request failed, error: ' + error.message);
      });
  }

  function checkForNotificationPermission() {
    CastledNotifications.getPushPermission().then((pushEnabled) => {
      if (pushEnabled) {
        console.log('Does have push notification permission');
      } else {
        console.log('Does not have push notification permission');
      }
    });
  }

  function getInboxUnreadCount() {
    CastledNotifications.getInboxUnreadCount().then((unreadCount) => {
      console.log('Inbox unread count: ' + unreadCount);
    });
  }
  React.useEffect(() => {
    CastledNotifications.initialize(configs);
    // promptForNotificationPermission();

    // Return cleanup function
    return () => {
      // Cleanup tasks (unsubscribe from subscriptions, remove event listeners, etc.)
      pushClickedListener.remove();
      pushReceivedListener.remove();
      pushDismissedListener.remove();
      inAppClickedListener.remove();
      inboxClickedListener.remove();
    };
  }, [
    pushClickedListener,
    pushReceivedListener,
    pushDismissedListener,
    inAppClickedListener,
    inboxClickedListener,
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
        <Text style={styles.title}>Push</Text>
        <View style={styles.buttonContainer}>
          <View style={styles.equal}>
            <Button
              title="Get Status"
              onPress={() => {
                checkForNotificationPermission();
              }}
            />
          </View>
          <View style={styles.horizontalSeparator} />
          <View style={styles.equal}>
            <Button
              title="Request"
              onPress={() => {
                promptForNotificationPermission();
              }}
            />
          </View>
        </View>
        <Separator />
        <Text style={styles.title}>Inbox</Text>
        <Button
          title="Navigate to Inbox"
          onPress={() => {
            getInboxUnreadCount();
            CastledNotifications.showAppInbox(inboxConfigs);
          }}
        />
        <Separator />
        <Text style={styles.title}>InApp Rendering</Text>
        <View style={styles.buttonContainer}>
          <View style={styles.equal}>
            <Button
              title="Pause"
              onPress={() => {
                CastledNotifications.pauseInApp();
              }}
            />
          </View>
          <View style={styles.horizontalSeparator} />
          <View style={styles.equal}>
            <Button
              title="Resume"
              onPress={() => {
                CastledNotifications.resumeInApp();
              }}
            />
          </View>
          <View style={styles.horizontalSeparator} />
          <View style={styles.equal}>
            <Button
              title="Stop"
              onPress={() => {
                CastledNotifications.stopInApp();
              }}
            />
          </View>
        </View>
        <Separator />
        <Text style={styles.title}>Log Screen Viewed Inapp example</Text>
        <Button
          title=" Screen Viewed"
          onPress={() => {
            CastledNotifications.logPageViewedEvent('DetailsScreen');
          }}
        />
        <Separator />
        <Text style={styles.title}>Event tracking/ Custom In-app</Text>
        <View style={styles.buttonContainer}>
          <View style={styles.equal}>
            <Button
              title="Log Event"
              onPress={() => {
                CastledNotifications.logEvent(testData.event, testData.params);
              }}
            />
          </View>
          <View style={styles.horizontalSeparator} />
          <View style={styles.equal}>
            <Button
              title="Log User Attributes"
              onPress={() => {
                CastledNotifications.setUserAttributes(userAttrs);
              }}
            />
          </View>
        </View>

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
  buttonContainer: {
    // flex: 1,
    flexDirection: 'row',
    //justifyContent: 'space-evenly',
    alignItems: 'center',
    width: '100%', // Make sure the container takes full width
  },
  horizontalSeparator: {
    width: 10, // Width of the separator line
    backgroundColor: 'transparent', // Color of the separator line
  },
  equal: {
    flex: 1,
  },
});
