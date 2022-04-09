import { NativeModules, Platform } from 'react-native';

export interface MediaInfo {
  shazamID: string | null;
  title: string | null;
  subtitle: string | null;
  artist: string | null;
  genres: [string];
  appleMusicID: string | null
  appleMusicURL: string | null
  webURL: string | null
  artworkURL: string | null
  videoURL: string | null
  explicitContent: boolean
  isrc: string | null
}

const LINKING_ERROR =
  `The package 'react-native-shazam-kit' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo managed workflow\n';

const ShazamKit = NativeModules.ShazamKit
  ? NativeModules.ShazamKit
  : new Proxy(
      {},
      {
        get() {
          throw new Error(LINKING_ERROR);
        },
      }
    );

export function isSupported(): Promise<boolean> {
  return ShazamKit.isSupported("");
}

export function stop(): Promise<boolean> {
  return ShazamKit.stop("");
}

export async function listen(): Promise<MediaInfo> {
  const result = await ShazamKit.listen("");

  return JSON.parse(result);
}