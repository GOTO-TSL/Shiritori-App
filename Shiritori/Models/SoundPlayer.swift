//
//  SoundPlayer.swift
//  Shiritori
//
//  Created by 後藤孝輔 on 2021/06/26.
//

import AVFoundation
import Foundation

/// サウンドを管理するモデル
final class SoundPlayer {
    var audioPlayer: AVAudioPlayer!
    
    /// サウンドを再生する
    /// - Parameters:
    ///   - name: 再生したいサウンド名
    ///   - isMute: ミュート状態かどうか
    ///   - loop: ループ再生するか
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
    
    /// サウンドの再生を停止
    func stopSound() {
        audioPlayer.stop()
    }
    
    /// サウンドの音量を０（ミュート状態にする）
    /// - Parameter isMute: 現在ミュート状態かどうか
    func muteSound(isMute: Bool) {
        audioPlayer.volume = isMute ? 0.0 : 1.0
    }
}
