//
//  ViewController.swift
//  VideoCheck
//
//  Created by Ranosys_Technologies on 10/10/18.
//  Copyright © 2018 Ranosys_Technologies. All rights reserved.
//

import UIKit
import AVFoundation
import DFLivelinessAuth
import Photos

class ViewController: UIViewController {
    
    var player = AVPlayer()
    var playerLayer = AVPlayerLayer()
    var globalURL: URL?
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
        let DFVLInstance = DFLivelinessAuth.sharedInstance

        DFVLInstance.getRecordedVideo(success: { (data, status) in
            if status {
                
                guard var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                url.appendPathComponent("video.mp4") // or whatever extension the video is
                do {
                    try data.write(to: url, options: .atomic)
                } catch {
                }
                self.globalURL = url
                
            } else {
                self.showAlert("Spoken words are incorrect, please try again.", title: "")
            }
        }, failure: { (error) in
            print(error)
        })

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
