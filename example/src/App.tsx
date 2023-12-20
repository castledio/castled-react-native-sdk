import * as React from 'react';

import { StyleSheet, View, Text } from 'react-native';
import {
  CastledNotifications,
  CastledConfigs,
  CastledLocation,
} from 'castled-react-native-sdk';

const configs = new CastledConfigs();
configs.appId = '829c38e2e359d94372a2e0d35e1f74df';
configs.location = CastledLocation.US;
configs.enableInApp = true;

export default function App() {
  const [result, setResult] = React.useState<number | undefined>();

  React.useEffect(() => {
    CastledNotifications.initialize(configs);
  }, []);

  return (
    <View style={styles.container}>
      <Text>Result: Castled Init Successful!</Text>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  box: {
    width: 60,
    height: 60,
    marginVertical: 20,
  },
});
