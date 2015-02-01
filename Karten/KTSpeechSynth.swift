import Foundation
import AVFoundation

@objc public class KTSpeechSynth : NSObject {
    
    var synthesizer : AVSpeechSynthesizer
    var voice : AVSpeechSynthesisVoice
    
    override init() {
        synthesizer = AVSpeechSynthesizer()
        voice = AVSpeechSynthesisVoice(language: "de-DE")
    }
    
    public func speak(spokenString: String) -> () {
        var utterance = AVSpeechUtterance(string: spokenString)
        utterance.rate = 0.14;
        utterance.voice = voice
        utterance.pitchMultiplier = 0.9;
        synthesizer.speakUtterance(utterance)
    }
}
