import * as React from 'react';

import { StyleSheet, View, Text, Image } from 'react-native';
import ShazamKit, { MediaInfo } from 'react-native-shazam-kit';

export default function App() {
  const [result, setResult] = React.useState<MediaInfo | undefined>();
  const [error, setError] = React.useState<string | undefined>();

  React.useEffect(() => {
    ShazamKit.listen().then(media => {
      setResult(media);
    }).catch(e => {
      setError(e.message);
    });
  }, []);

  return (
    <View style={styles.container}>
      { result && (
        <>
          <Image source={{ uri: result.artworkURL }} style={{ width: 256, height: 256 }} />
          <Text>Title: {result.title}</Text>
          <Text>Artist: {result.artist}</Text>
        </>
      ) }
      { error && <Text>Error: {error}</Text> }
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
