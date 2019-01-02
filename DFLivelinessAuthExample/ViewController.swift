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
        let DFVLInstance = DFLivelinessAuthConstant.sharedInstance

        DFVLInstance.getRecordedVideo(success: { (data, status) in
            if status {
//                guard  let vc = self.storyboard?.instantiateViewController(withIdentifier: StoryBoard.Identifier.videoUploadGuidance) as? VideoUploadGuidance else { return }
//                vc.videoData = data
//                vc.verificationStatus = status
//                self.navigationController?.pushViewController(vc, animated: true)
            } else {
             //   self.showAlert("Spoken words are incorrect, please try again.", .failure, nil)
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
