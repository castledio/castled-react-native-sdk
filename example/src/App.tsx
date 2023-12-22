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
} from 'castled-react-native-sdk';
import Header from './Header';

const Separator = () => <View style={styles.separator} />;

const configs = new CastledConfigs();
configs.appId = '829c38e2e359d94372a2e0d35e1f74df';
configs.enableTracking = true;
configs.location = CastledLocation.US;
configs.enableInApp = true;
configs.enablePushBoost = true;
configs.enablePush = true;
configs.inAppFetchIntervalSec = 300;

export default function App() {
  const testData = {
    user: 'frank@castled.io',
    event: 'rn_test_event_2',
    params: {
      str: 'val1',
      num: 10,
      bool: true,
    },
  };

  React.useEffect(() => {
    CastledNotifications.initialize(configs);
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
