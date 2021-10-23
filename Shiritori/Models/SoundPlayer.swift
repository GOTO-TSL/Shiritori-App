//
//  SoundPlayer.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/10/23.
//

import AVFoundation

final class SoundPlayer {
    var audioPlayer: AVAudioPlayer!
    
    func playSound(name: String, loop: Int = 0) {
        let isMute = UserDefaults.standard.bool(forKey: Const.UDKeys.isMute)
        
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
            audioPlayer.volume = isMute ? 0.0 : 0.5
            // 音楽の再生
            audioPlayer.play()
            
        } catch {
            print("Error\(error)")
        }
    }
    
    // サウンドの再生を停止
    func stop() {
        audioPlayer.stop()
    }
    
    func changeVolume() {
        let isMute = UserDefaults.standard.bool(forKey: Const.UDKeys.isMute)
        audioPlayer.volume = isMute ? 0.0 : 0.5
    }
}
