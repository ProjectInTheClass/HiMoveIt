//
//  EditorViewController.swift
//  HiMoveIt
//
//  Created by GW_09 on 07/08/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit
import AVKit

class EditorViewController: UIViewController {
    var asset:AVAsset?
    var maskedImage:CGImage?
    var player:AVPlayer?
    var playerLayer:AVPlayerLayer?
    var playerItem:AVPlayerItem?
    @IBOutlet weak var playGround: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func prepareForLayer(){
        let image = UIImage(cgImage: maskedImage!)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = playGround.bounds
        playGround.addSubview(imageView)

    }
    func prepareForPlay(){
        guard self.asset != nil else{
            print("asset is nil")
            return
        }
        playerItem = AVPlayerItem(asset: self.asset!)
        self.player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer!.videoGravity = .resizeAspectFill
        playerLayer?.frame = playGround.bounds
        playGround.layer.addSublayer(playerLayer!)
        
    }
    
    func editPlay(){
        guard player != nil else{
            return
        }
        self.player!.seek(to: CMTime(seconds: 0, preferredTimescale: 600))
        player?.play()
    }

    func initSet(asset:AVAsset, maskedImage:CGImage){
        self.asset = asset
        self.maskedImage = maskedImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.prepareForPlay()
        self.prepareForLayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player?.pause()
    }
    
    
    @IBAction func cllickPlayBtn(_ sender: Any) {
        editPlay()
    }
    
    @IBAction func clickCencelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func pageClose(){
        self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.dismiss(animated: true, completion: nil)
        })
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.dismiss(animated: true, completion: nil)
        })
        
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: {
            self.dismiss(animated: true, completion: nil)
        })
        self.presentingViewController?.dismiss(animated: true, completion: {
            self.dismiss(animated: true, completion: nil)
        })
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickDoneBtn(_ sender: Any) {
        guard asset != nil , maskedImage != nil else {
            return
        }
        let renderer = RenderModel(asset: asset!, maskedImage: maskedImage!)
        _ = renderer.render()
        FloatAlertModel(rootView: self).createAlert(title: "생성완료", message: "성공적으로 생성되었습니다.",funcd:pageClose)
    }
    
    
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
