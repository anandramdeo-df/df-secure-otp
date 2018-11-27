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

        DFVLInstance.initialize(success: { [weak self] viewController in

            DFVLInstance.guidanceHeadingText = "Scan the Document."
            DFVLInstance.guidanceHeadingTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            DFVLInstance.guidanceDescriptionTextColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

            DFVLInstance.regularFont = "Marker Felt"
            DFVLInstance.boldFont = "Marker Felt"

            DFVLInstance.guidanceContinueButtonBgColor = #colorLiteral(red: 0.4078431373, green: 0.7058823529, blue: 0.3647058824, alpha: 1)
            DFVLInstance.guidanceCancelButtonTextColor = #colorLiteral(red: 0.4078431373, green: 0.7058823529, blue: 0.3647058824, alpha: 1)

            DFVLInstance.guidanceBgColor =  #colorLiteral(red: 0.9098039216, green: 0.3921568627, blue: 0.3647058824, alpha: 1)
            DFVLInstance.videoVCGradientColor = #colorLiteral(red: 0.9098039216, green: 0.3921568627, blue: 0.3647058824, alpha: 0.581255008)

            if let vc = viewController {
                vc.delegate = self
                let navVc = UINavigationController(rootViewController: vc)
                self?.present(navVc, animated: true, completion: nil)
            }
            }, failure: { (error) in
                print(error?.userInfo ?? "Your api token is not valid")
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
