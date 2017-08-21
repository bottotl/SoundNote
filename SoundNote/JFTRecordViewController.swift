//
//  JFTRecordViewController.swift
//  SoundNote
//
//  Created by jft0m on 2017/8/21.
//  Copyright © 2017年 jft0m. All rights reserved.
//

import UIKit
import AVFoundation

class JFTRecordViewController: UIViewController {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
//    var isRecording : Bool = false
    var lastFileURL : URL? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func recordButtonTouchDown(_ sender: Any) {
        print("开始录音")
        self.startAudioRecordWithUrl(url : URL.init(fileURLWithPath: self.makeAudioPath()))
    }
    
    @IBAction func recordButtonTouchCancel(_ sender: Any) {
        print("停止录音")
        self.lastFileURL = self.audioRecorder.url
        print(self.lastFileURL as Any)
        self.audioRecorder.stop()
        self.audioRecorder = nil
    }
    
    func startAudioRecordWithUrl(url : URL) {
        print(url)
        if self.audioRecorder == nil {
            do {
                self.audioRecorder = try AVAudioRecorder.init(url: url, settings: self.audioSettings())
            } catch let error {
                print(error)
            }
            
        }
        if self.audioRecorder!.isRecording {
            // Not allow record
            return
        }
        self.audioRecorder!.record()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            self.audioRecorder.record()
            print("start record")
        } catch let error {
            print(error)
        }
    }
    
    func createAudioSession() -> AVAudioSession {
        let audioSession = AVAudioSession.sharedInstance();
        return audioSession
    }
    
    func makeAudioPath() -> String {
        let fileManager = FileManager.default
        let dir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/Audio/");
        if !fileManager.fileExists(atPath: dir!) {
            try? fileManager.createDirectory(atPath: dir!, withIntermediateDirectories: true, attributes: nil)
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        var fileName = formatter.string(from: Date.init(timeIntervalSinceNow: 0))
        fileName = fileName + "_\(Int(arc4random_uniform(10000) + 1))" + ".caf"
        return dir!.appending(fileName)
    }
    
    func audioSettings() -> [String : Any] {
        let settings = [AVSampleRateKey          : NSNumber(value: Float(44100.0)),
                        AVFormatIDKey            : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
                        AVNumberOfChannelsKey    : NSNumber(value: 1),
                        AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]
        return settings
    }
}
