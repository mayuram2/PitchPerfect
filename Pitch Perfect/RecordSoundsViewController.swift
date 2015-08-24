//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Sruthi Mayuram Krithivasan on 8/21/15.
//  Copyright (c) 2015 Sruthi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeButton.hidden = true
        recordButton.enabled = true
        recordingInProgress.text = "Tap to record"
    }
    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.text = "Recording in progress"
        stopButton.hidden = false
        pauseButton.hidden = false
        resumeButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopAudio(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func pauseResume(sender: UIButton) {
        if(sender.tag==1)
        {
            recordingInProgress.text = "Recording paused"
            audioRecorder.pause()
        }
        else if(sender.tag==2)
        {
            recordingInProgress.text = "Recording in progress"
            audioRecorder.record()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier=="stopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.recordedAudio = data
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            recordButton.enabled = true
            stopButton.hidden = true
            pauseButton.hidden = true
            resumeButton.hidden = true
        }
    }
    
}

