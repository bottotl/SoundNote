//
//  JFTRecordViewController.swift
//  SoundNote
//
//  Created by jft0m on 2017/8/21.
//  Copyright © 2017年 jft0m. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class JFTRecordViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    
    var lastFileURL : URL? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isHidden = true
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch {
        }
        
        let codeTimer = DispatchSource.makeTimerSource(queue:DispatchQueue.global())
        codeTimer.scheduleRepeating(deadline: .now(), interval: .seconds(1))
        codeTimer.setEventHandler(handler: {
            if self.audioPlayer != nil {
                print("\(self.audioPlayer.isPlaying)")
            }
        })
        codeTimer.resume()
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
        self.stopRecord()
    }
    
    @IBAction func playButtonClick(_ sender: Any) {
        if lastFileURL == nil {return}
        do {
            audioPlayer = try AVAudioPlayer.init(contentsOf: lastFileURL!)
            audioPlayer.volume = 1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            audioPlayer.delegate = self
            print("play!!")
        } catch let error {
            print(error)
        }
        
    }
    
    func startAudioRecordWithUrl(url : URL) {
        print(url)
        if audioRecorder == nil {
            do {
                audioRecorder = try AVAudioRecorder.init(url: url, settings: self.audioSettings())
                audioRecorder.prepareToRecord()
            } catch let error {
                print(error)
            }
            
        }
        if self.audioRecorder!.isRecording {
            // Not allow record
            return
        }
        self.audioRecorder!.record()
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(true)
            self.audioRecorder.record()
            print("start record")
        } catch let error {
            print(error)
        }
    }
    
    func stopRecord() {
        lastFileURL = audioRecorder.url
        print(lastFileURL as Any)
        do {
            audioRecorder.stop()
            audioRecorder = nil
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setActive(false)
            playButton.isHidden = false
            self.storeSound(fileName: (lastFileURL?.lastPathComponent)!)
        } catch let error {
            print(error)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        print("audioPlayerDidFinishPlaying")
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("error ")
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
    // core data
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func storeSound(fileName : String){
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Sound", in: context)
        
        let person = NSManagedObject(entity: entity!, insertInto: context)
        
        person.setValue(fileName, forKey: "filename")
        
        do {
            try context.save()
            print("saved")
        }catch{
            print(error)
        }
    }
}
