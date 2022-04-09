import ShazamKit

@objc(ShazamKit)
class ShazamKit: NSObject {
    
    private var shazamSession: Any? = nil
    private var audioEngine: AVAudioEngine? = nil
    
    private var resolveBlock: RCTPromiseResolveBlock? = nil
    private var rejectBlock: RCTPromiseRejectBlock? = nil
    
    @objc(requiresMainQueueSetup)
    static var requiresMainQueueSetup: Bool {
        return true
    }
    
    @objc(isSupported:withResolver:withRejecter:)
    func isSupported(empty: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        guard #available(iOS 15.0, *) else {
            resolve(false)
            
            return
        }
        
        resolve(true)
    }
    
    @objc(listen:withResolver:withRejecter:)
    func listen(empty: String, resolve: @escaping RCTPromiseResolveBlock, reject: @escaping RCTPromiseRejectBlock) {
        self.resolveBlock = resolve
        self.rejectBlock = reject
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case .granted:
            startShazam()
            
        case .denied:
            reject("ERR_PERMISSION_DENIED", "The audio record permission was denied by the user.", nil)
            
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission {
                if $0 {
                    self.startShazam()
                } else {
                    reject("ERR_PERMISSION_DENIED", "The audio record permission was denied by the user.", nil)
                }
            }
            
        @unknown default:
            reject("ERR_UNKNOWN", "An unknown error has occurred.", nil)
        }
    }
    
    @objc(stop:withResolver:withRejecter:)
    func stop(empty: String, resolve: RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) -> Bool {
        self.resolveBlock = nil
        self.rejectBlock = nil
        
        cleanup()
        
        resolve(true)
    }
}

extension ShazamKit {
    
    private func startShazam() {
        if #available(iOS 15.0, *) {
            shazamSession = SHSession()
            audioEngine = AVAudioEngine()
            
            guard let shazamSession = shazamSession as? SHSession, let audioEngine = audioEngine else {
                return
            }
            
            shazamSession.delegate = self
            
            audioEngine.inputNode.removeTap(onBus: .zero)
            audioEngine.inputNode.installTap(onBus: .zero, bufferSize: 2048, format: audioEngine.inputNode.inputFormat(forBus: .zero)) { (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
                shazamSession.matchStreamingBuffer(buffer, at: time)
            }
            
            audioEngine.prepare()
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.record)
                
                try audioEngine.start()
            } catch {
                rejectBlock?("ERR_ENGINE_START", "Unable to start AVAudioEngine.", error)
            }
        } else {
            rejectBlock?("ERR_LOW_IOS_VERSION", "iOS 15 or newer is required.", nil)
        }
    }
    
    private func cleanup() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: .zero)
        audioEngine = nil
        
        shazamSession = nil
        
        resolveBlock = nil
        rejectBlock = nil
    }
}

extension ShazamKit: RCTInvalidating {
    
    func invalidate() {
        cleanup()
    }
}

@available(iOS 15.0, *)
extension ShazamKit: SHSessionDelegate {
    
    internal func session(_ session: SHSession, didFind match: SHMatch) {
        defer { cleanup() }
        
        if let matchedMedia = match.mediaItems.first {
            do {
                let media = BridgedMedia(mediaItem: matchedMedia)
                
                let encoder = JSONEncoder()
                let jsonData = try encoder.encode(media)
                let json = String(data: jsonData, encoding: .utf8)
                
                resolveBlock?(json)
            } catch {
                rejectBlock?("ERR_ENCODING", "Unable to encode media data to JSON.", nil)
            }
        } else {
            rejectBlock?("ERR_NO_MATCH", "A match was not found.", nil)
        }
    }
    
    internal func session(_ session: SHSession, didNotFindMatchFor signature: SHSignature, error: Error?) {
        defer { cleanup() }
        
        rejectBlock?("ERR_NO_MATCH", "A match was not found.", nil)
    }
}
