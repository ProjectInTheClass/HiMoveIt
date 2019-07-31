//
//  RecordViewController.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 19/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController,AVCaptureFileOutputRecordingDelegate{
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        
    }
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var cameraLayer: UIView!
    var recordCameraModel:RecordCameraModel?
    var recordStatus:RecordStatusModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordCameraModel = RecordCameraModel(cameraLayer: cameraLayer, rootView: self)
        self.recordStatus = RecordStatusModel()
        self.roundBtn(recordBtn);
        
    }
    func roundBtn(_ object:AnyObject){
        object.layer?.cornerRadius = (object.frame?.size.width)!/2;
        object.layer?.masksToBounds = true;
    }
    func squareBtn(_ object:AnyObject){
        object.layer?.cornerRadius = 0;
        object.layer?.masksToBounds = true;
    }
    
    func setSwipeTransition(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    func loadEditorView(fileURL:NSURL){
        setSwipeTransition()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Editor", bundle: nil)
        let editorViewController = storyBoard.instantiateViewController(withIdentifier: "editorView") as! EditorViewController
        editorViewController.setRecURL(fileURL: fileURL)
        self.present(editorViewController, animated: false, completion: nil)
    }
    
    @IBAction func clickRecordBtn(_ sender: Any) {
        if recordStatus!.isRecordOn() { //정지처리
            recordStatus!.setRecordOn(status: false);
            roundBtn(recordBtn)
            let fileURL:NSURL = (recordCameraModel?.stopRec())!
            loadEditorView(fileURL:fileURL)
        }else{ //녹화처리
            recordStatus!.setRecordOn(status: true);
            squareBtn(recordBtn)
            recordCameraModel?.startRec()

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {        // view가 나타날때 player 재생
        super.viewDidAppear(animated)
        UIView.transition(with: self.cameraLayer, duration: 0.5, options: .transitionFlipFromLeft, animations: {
            self.cameraLayer.isHidden = false
            self.recordCameraModel?.setCamera()
        }, completion: nil)
    }
    
    @IBAction func clickFlashBtn(_ sender: Any) {
        if recordStatus!.isFlashOn() { //플레시 끄기
            recordCameraModel?.offFlash()
            recordStatus!.setFlashOn(status: false);
        }else{ //플레시 켜기
            recordCameraModel?.onFlash()
            recordStatus!.setFlashOn(status: true);
            
        }
    }
    @IBAction func clickChangeCam(_ sender: Any) {
        if (recordStatus?.isCamFront())!{ //백으로 전환
            UIView.transition(with: self.cameraLayer, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.cameraLayer.isHidden = false
                self.recordCameraModel?.backCam()
            }, completion: nil)
            
            recordStatus!.setCamIsFront(stauts: false)
        }else{ //프론트로 전환
            UIView.transition(with: self.cameraLayer, duration: 0.5, options: .transitionFlipFromLeft, animations: {
                self.cameraLayer.isHidden = false
                self.recordCameraModel?.frontCam()
            }, completion: nil)
            recordStatus!.setCamIsFront(stauts: true)
        }
    }
    
    
    @IBAction func clickCancelBtn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
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
