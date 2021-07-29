//
//  SoundPlayer.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/26.
//

import AVFoundation
import Foundation

class SoundPlayer {
    var audioPlayer: AVAudioPlayer!
    
    func playSound(name: String, isMute: Bool = false, loop: Int = 0) {
        guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else {
            print("音楽ファイルが見つかりません")
            return
        }
        
        do {
            // AVAudioPlayerのインスタンス化
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            // AVAudioPlayerのデリゲートをセット
            audioPlayer.delegate = self as? AVAudioPlayerDelegate
            // ループ数の指定
            audioPlayer.numberOfLoops = loop
            // 音量設定
            audioPlayer.volume = isMute ? 0.0 : 1.0
            // 音楽の再生
            audioPlayer.play()
        } catch {
            print("Error\(error)")
        }
    }
    
    func stopSound() {
        audioPlayer.stop()
    }
    
    func muteSound(isMute: Bool) {
        audioPlayer.volume = isMute ? 0.0 : 1.0
    }
}
