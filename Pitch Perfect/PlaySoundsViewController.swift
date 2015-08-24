//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sruthi Mayuram Krithivasan on 8/21/15.
//  Copyright (c) 2015 Sruthi. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var recordedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: recordedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recordedAudio.filePathUrl, error: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioAtRate(1.5)
    }
    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioAtRate(0.5)
    }

    @IBAction func chipMunkAudio(sender: UIButton) {
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = 1000
        playAudioWithEffect(changePitchEffect)
    }
    
    @IBAction func darthEffectAudio(sender: UIButton) {
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = -1000
        playAudioWithEffect(changePitchEffect)
    }
    
    @IBAction func echoAudio(sender: UIButton) {
        var echoNode = AVAudioUnitDelay()
        echoNode.delayTime = 0.2
        playAudioWithEffect(echoNode)
    }
    
    @IBAction func reverbAudio(sender: UIButton) {

        var unitReverb = AVAudioUnitReverb()
        unitReverb.wetDryMix = 100.0
        playAudioWithEffect(unitReverb)
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func clearAudio()
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func playAudioAtRate(playRate: Float) {
        clearAudio()
        audioPlayer.rate = playRate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithEffect(audioEffect: AVAudioNode)
    {
        clearAudio()
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioEffect)
        audioEngine.connect(audioPlayerNode, to: audioEffect, format: nil)
        audioEngine.connect(audioEffect, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
}
