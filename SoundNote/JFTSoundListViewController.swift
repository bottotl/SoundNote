//
//  JFTSoundListViewController.swift
//  SoundNote
//
//  Created by jft0m on 2017/8/21.
//  Copyright © 2017年 jft0m. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

class JFTSoundListViewController: UITableViewController {
    var dataSource : [String] = []
    var dir : String = ""
    
    var audioPlayer: AVAudioPlayer!
    
    var playingIndex : Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(JFTAudioCell().classForCoder, forCellReuseIdentifier: "cell")
        let fileManager = FileManager.default
        dir = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first?.appending("/Audio/"))!;
        if !fileManager.fileExists(atPath: dir) {
            try? fileManager.createDirectory(atPath: dir, withIntermediateDirectories: true, attributes: nil)
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Sound")
        
        do {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let searchResults = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest)
            print("numbers of \(searchResults.count)")
            
            for p in (searchResults as! [NSManagedObject]){
                let fileName = p.value(forKey: "filename")
                dataSource.append(fileName as! String)
            }
            tableView.reloadData()
        } catch  {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! JFTAudioCell
        cell.fileNameLabel?.text = self.dataSource[indexPath.row];
        cell.playButton.tag = indexPath.row
        cell.playButton.addTarget(self, action: #selector(playButtonClick(button:)), for: UIControlEvents.touchUpInside)
        if indexPath.row == playingIndex {
            cell.backgroundColor = UIColor.green
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    @objc func playButtonClick(button : UIButton) {
        playingIndex = button.tag
        self.playSound()
    }
    
    func playSound() {
        if playingIndex < 0 {return}
        tableView.reloadData()
        let fileUrl = URL.init(fileURLWithPath: dir.appending(dataSource[playingIndex]))
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
            audioPlayer = try AVAudioPlayer.init(contentsOf: fileUrl)
            audioPlayer.volume = 1
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            print("play!!")
        } catch let error {
            print(error)
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
    }

}
