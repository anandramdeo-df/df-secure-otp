//
//  ViewController.swift
//  VideoCheck
//
//  Created by Ranosys_Technologies on 10/10/18.
//  Copyright © 2018 Ranosys_Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import VideoLivelinessFramework

class ViewController: UIViewController {
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var globalURL = URL(string: "")
    @IBOutlet weak var previewLayerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        previewLayerView.layer.borderWidth = 1
        previewLayerView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick(_ sender: Any) {
        let vc = GuidanceViewController.storyboardInstance()
        vc?.delegate = self
        vc?.messageText = "Please Speak numbers"
        let navVc = UINavigationController(rootViewController: vc!)
        present(navVc, animated: true, completion: nil)
    }
    
    @IBAction func play(_ sender: Any) {
        if let url = globalURL {
            player = AVPlayer(url: url)
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = previewLayerView.frame
            previewLayerView.layer.addSublayer(playerLayer)
            player.play()
        }
    }
}

extension ViewController: GetRecordedVideo {
    func recordedVideo(videoData: Data, status: Bool) {
        if status {
            globalURL = URL(string: "")
            let tmpFileURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("video").appendingPathExtension("MP4")
            DispatchQueue.main.async {
                _ = (try? videoData.write(to: tmpFileURL, options: [.atomic])) != nil
            }
            
            globalURL = tmpFileURL
            self.showAlert("Speech to text for numbers is verified", title: "SUCCESS")
        } else {
            self.showAlert("Speech to text for numbers is not verified", title: "FAILURE")
        }
        print("Spoken words are incorrect")
    }
}

extension ViewController {
    func showAlert(_ message: String?, title: String?) {
        if let msg = message {
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            DispatchQueue.main.async {
                self.present(alert, animated: true, completion: nil)
                
            }
        }
    }
}
