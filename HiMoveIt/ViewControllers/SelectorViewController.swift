//
//  EditorViewController.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 19/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit

class SelectorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var playGround: UIView!
    @IBOutlet weak var getTimeBar: UISlider!
    
    var recFileURL:NSURL?
    var playerLayer:AVPlayerLayer?
    var playerItem:AVPlayerItem?
    var playAsset:AVAsset?
    var player:AVPlayer?
    var playOnReady:Bool = false;
    private var playerItemContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setAsset(asset:AVAsset){
        self.playAsset = asset
    }
    
    func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func procNextPreparing() {
        self.playerItem = AVPlayerItem(asset: self.playAsset!)
        self.player = AVPlayer(playerItem:self.playerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer!.videoGravity = .resizeAspectFill
        self.playOnReady = true;
        self.videoPlay();
    }
    
    func setSliderValue(data:Double){
        let timerate = (data / (playAsset?.duration.seconds)!) * 100
        self.getTimeBar.setValue(Float(timerate), animated: true)
    }
    
    func videoPlay(){
        if(playOnReady){
            self.playerLayer!.frame = self.playGround.bounds
            self.playGround.layer.addSublayer(self.playerLayer!)
            let interval = CMTime(seconds: 0.005, preferredTimescale: CMTimeScale(NSEC_PER_MSEC))
            let mainQueue = DispatchQueue.main
            self.player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { self.setSliderValue(data: $0.seconds)})
            player!.play()
        }
    }
    func setSwipeTransition(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        //view.window!.layer.add(transition, forKey: kCATransition)
    }
    func loadSelectorView(image:UIImage){
        //setSwipeTransition()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Editor", bundle: nil)
        let maskViewController = storyBoard.instantiateViewController(withIdentifier: "maskView") as! MaskViewController
        maskViewController.initSet(asset: playAsset!, image: image)
        self.present(maskViewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {        // view가 나타날때 player 재생
        super.viewDidAppear(animated)
        self.procNextPreparing()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player?.pause()
    }
    
    @IBAction func clickCancelBtn(_ sender: Any) {
        goBack()
    }
    
    

    @IBAction func clickDoneBtn(_ sender: Any) {
        //self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        let imageGenerator = AVAssetImageGenerator(asset: playAsset!)
        let sliderValue:Float = self.getTimeBar.value
        let realTime = Double( sliderValue/100 ) * ((playAsset?.duration.seconds)!)
        let seekTime = [NSValue(time: CMTime(seconds: realTime, preferredTimescale:(playAsset?.duration.timescale)!))]
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero
        imageGenerator.appliesPreferredTrackTransform = true
        imageGenerator.generateCGImagesAsynchronously(forTimes: seekTime) { _, image, _, _, _ in
            if image != nil {
                self.loadSelectorView(image: UIImage(cgImage: image!))
            }
        }
        
    }
    
    @IBAction func chantedSlider(_ sender: Any) {
        let sliderValue:Float = self.getTimeBar.value
        let realTime = Double( sliderValue/100 ) * ((playAsset?.duration.seconds)!)
        let seekTime = CMTime(seconds: realTime, preferredTimescale:(playAsset?.duration.timescale)!)
        self.player?.seek(to: seekTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.pause()
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

