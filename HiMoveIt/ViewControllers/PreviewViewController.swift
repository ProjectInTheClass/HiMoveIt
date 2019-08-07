//
//  PreviewController.swift
//  HiMoveIt
//
//  Created by KangKyung on 22/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import Photos
import Regift

class PreviewController: UIViewController {
    
    var shareImage = URL(fileURLWithPath: Bundle.main.path(forResource:"", ofType: "mov") ?? "")
    func convertGif(){
        let path: URL = imageUrl
        let frameCount = 16
        let delayTime  = Float(0.2)
        let loopCount  = 0    // 0 means loop forever
    
        let regift = Regift(sourceFileURL: path, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
            print("Gif saved to \(regift.createGif())")
        
        self.shareImage = regift.createGif()!
    }

    @IBOutlet weak var preViewImage: UIImageView!
    
    var image: UIImage = UIImage()
    var imageUrl: URL!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let player = AVPlayer(url: imageUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true){
            playerViewController.player?.play()
        }
    }
    
    func setImage(image: UIImage, url: URL,number: Int){
        self.image = image
        self.imageUrl = url
        self.index = number
    }
    
    override func viewDidAppear(_ animated: Bool) {
        preViewImage.image = image
    }
    
    func loadMainView(){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! MainViewController
        mainViewController.removeImage(indx: index!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnShare(_ sender: Any) {
        
        convertGif()
        
        let vc = UIActivityViewController(activityItems: [shareImage], applicationActivities: [])

        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        let player = AVPlayer(url: imageUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true){
            playerViewController.player?.play()
        }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        loadMainView()
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



