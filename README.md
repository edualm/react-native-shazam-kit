# react-native-shazam-kit

Use ShazamKit for song recognition from within React Native.

This module is only supported on iOS. Using it in Android will not crash your app - you can easily check for support using the `isSupported()` method.

## Installation

```sh
npm install react-native-shazam-kit
```

## Usage

```js
import ShazamKit from "react-native-shazam-kit";

// ...

if (await ShazamKit.isSupported()) {
    const result = await ShazamKit.listen();
}
```

## License

MIT
