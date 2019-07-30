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

class EditorViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
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
    
    func setRecURL(fileURL:NSURL){
        self.recFileURL = fileURL
        
    }
    
    func goBack(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    func setParamVideo(){
        playAsset = AVAsset(url: recFileURL! as URL)
        
        playAsset?.loadValuesAsynchronously(forKeys:["playable"] , completionHandler: {
            var err:NSError? = nil
            let status = self.playAsset!.statusOfValue(forKey: "playable", error: &err)
            
            switch status {
            case .loaded:
                self.procNextPreparing()
                break
            case .failed:
                print("error:",err as Any)
                break
            default:
                print("error:",err as Any)
                break
            }
        })
        
        //로드하는 시간동안 본 함수가 살아있지 않고 죽어버리면 뒤져버림;;;;;;
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
        print("current time : ", data)
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
    
    override func viewDidAppear(_ animated: Bool) {        // view가 나타날때 player 재생
        super.viewDidAppear(animated)
        self.setParamVideo()
    }
    @IBAction func clickCancelBtn(_ sender: Any) {
        goBack()
    }
    
    

    @IBAction func clickDoneBtn(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func chantedSlider(_ sender: Any) {
        let sliderValue:Float = self.getTimeBar.value
        let realTime = Double( sliderValue/100 ) * ((playAsset?.duration.seconds)!)
        let seekTime = CMTime(seconds: realTime, preferredTimescale:(playAsset?.duration.timescale)!)
        player?.seek(to: seekTime)
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

