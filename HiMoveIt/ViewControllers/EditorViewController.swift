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

class EditorViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate{
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var playGround: UIView!
    
    var recFileURL:NSURL?
    var playerLayer:AVPlayerLayer?
    var playerItem:AVPlayerItem?
    var playAsset:AVAsset?
    var player:AVPlayer?
    var playOnReady:Bool = false;
    private var playerItemContext = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("URL : "+(recFileURL?.filePathURL?.absoluteString)!)
        // Do any additional setup after loading the view.
    }
    
    func setRecURL(fileURL:NSURL){
        self.recFileURL = fileURL
        self.setParamVideo()
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
        //playAsset?.loadValuesAsynchronously(forKeys: <#T##[String]#>, completionHandler: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
        self.playerItem = AVPlayerItem(asset: self.playAsset!)
        self.player = AVPlayer(playerItem:self.playerItem)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer!.videoGravity = .resize
        self.playOnReady = true;
        
        //로드하는 시간동안 본 함수가 살아있지 않고 죽어버리면 뒤져버림;;;;;;
    }
    
    override func viewDidLayoutSubviews() {            // subView인 playerLayer의 영역 설정
        super.viewDidLayoutSubviews()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {        // view가 나타날때 player 재생
        super.viewDidAppear(animated)
        if(playOnReady){
            self.playerLayer!.frame = self.playGround.bounds
            self.playGround.layer.addSublayer(self.playerLayer!)
            player!.play()
        }
    }
    @IBAction func clickCancelBtn(_ sender: Any) {
        goBack()
    }
    
    

    @IBAction func clickDoneBtn(_ sender: Any) {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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

