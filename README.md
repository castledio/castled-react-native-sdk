<p align="center">
  <a href="https://castled.io/#gh-light-mode-only">
    <img src="https://cdn.castled.io/logo/castled_logo_light_mode.png" width="318px" alt="Castled logo" />
  </a>
  <a href="https://castled.io/#gh-dark-mode-only">
    <img src="https://cdn.castled.io/logo/castled_logo_dark_mode.png" width="318px" alt="Castled logo" />
    <p align="center">Customer Engagement Platform for the Modern Data Stack</p>
  </a>
</p>

---

[![npm version](https://img.shields.io/npm/v/castled-react-native-sdk.svg)](https://www.npmjs.com/package/castled-react-native-sdk)
[![npm downloads](https://img.shields.io/npm/dm/castled-react-native-sdk)](https://www.npmjs.com/package/castled-react-native-sdk)
![min Android SDK version is 24](https://img.shields.io/badge/min%20Android%20SDK-24-green)
![iOS 13.0+](https://img.shields.io/badge/iOS-13.0+-blue.svg)

# Castled React Native SDK

## :star: Introduction

Castled React Native SDK enables React Native mobile applications running on iOS and Android devices to receive messages send from the Castled Customer Engagement Platform. This SDK facilitates:

- Receiving push notifications.
- Displaying in-app messages and app inbox notifications.
- Updating user profiles.
- Collecting user events.

The following steps will guide app developers on how to seamlessly integrate the SDK into their mobile applications.

## :roller_coaster: Getting Started

### Installing SDK

Add the library to your project

```bash npm
npm install castled-react-native-sdk
```

### Native Setup

#### Android

1.  Update `build.gradle`

    Include `google-services` plugin dependency in top-level gradle file

    ```gradle
    // Top-level android/build.gradle file where you can add configuration options common to all sub-projects/modules.
    buildscript {
        repositories {
            // Add google maven repository
            google()
        }
        ...
        dependencies {
            ...
            classpath("com.google.gms:google-services:<plugin-version>")
        }
    }

    ```

    Apply `google-services` plugin to app gradle file

    ```gradle android/app/build.gradle
        apply plugin: "com.google.gms.google-services"
    ```

2.  Add required permissions

    By default `AndroidManifest.xml` of the SDK includes the following permission requests. No developer action is required here.

    ```xml
    <!-- Castled SDK needs this permission to sync user token and campaign events  -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <!-- Castled SDK will use this permission to decide when to make network calls -->
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
    ```

#### iOS

1.  Pod Installation

    Navigate to ios directory of your app project and run `pod install`

### Initializing SDK

Next step is to initialize the SDK. Initialization is typically done in `App.js`.

```tsx
  import * as React from 'react';
  // Importing SDK modules required for initialization
  import {
    CastledNotifications,
    CastledConfigs,
    CastledLocation,
  } from 'castled-react-native-sdk';
  import Header from './Header';

  export default function App() {

    ...

    React.useEffect(() => {
      // Set config
      const configs = new CastledConfigs();
      configs.appId = '<app-id>';
      configs.location = CastledLocation.US;

      // Initialize SDK
      CastledNotifications.initialize(configs);
    }, []);

    ...

    return (
      <>
        ...
      </>
    );
  }
```

- `api-key` is a unique key associated with your Castled account. It can be found in the Castled dashboard at **Settings > Api Keys**.
- `location` is the region where you have your Castled account.

## :books: Documentation

More details about the SDK integration can be found at https://docs.castled.io/developer-resources/sdk-integration/reactnative/getting-started

## Contributing

See the [contributing guide](CONTRIBUTING.md) to learn how to contribute to the repository and the development workflow.

## License

MIT

---

Made with [create-react-native-library](https://github.com/callstack/react-native-builder-bob)
