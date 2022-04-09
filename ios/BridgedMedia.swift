import ShazamKit

public struct BridgedMedia: Codable {
    
    let shazamID: String?
    let title: String?
    let subtitle: String?
    let artist: String?
    let genres: [String]
    let appleMusicID: String?
    let appleMusicURL: URL?
    let webURL: URL?
    let artworkURL: URL?
    let videoURL: URL?
    let explicitContent: Bool
    let isrc: String?
    
    @available(iOS 15.0, *)
    init(mediaItem: SHMediaItem) {
        self.shazamID = mediaItem.shazamID
        self.title = mediaItem.title
        self.subtitle = mediaItem.subtitle
        self.artist = mediaItem.artist
        self.genres = mediaItem.genres
        self.appleMusicID = mediaItem.appleMusicID
        self.appleMusicURL = mediaItem.appleMusicURL
        self.webURL = mediaItem.webURL
        self.artworkURL = mediaItem.artworkURL
        self.videoURL = mediaItem.videoURL
        self.explicitContent = mediaItem.explicitContent
        self.isrc = mediaItem.isrc
    }
}
