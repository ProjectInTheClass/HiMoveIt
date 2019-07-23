//
//  RecordViewController.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 19/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController{
  
    var session: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice:AVCaptureDevice?
    var movieOutput: AVCaptureMovieFileOutput?
    
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var cameraLayer: UIView!
    
    var recoStatus:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundBtn(recordBtn);
        self.cameraSetting()
        // Do any additional setup after loading the view.
    }
//    override func viewDidAppear(_ animated: Bool) {
//        self.cameraSetting()
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        dismissCaptureSession()
//    }
    func cameraSetting(){
        captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        if(captureDevice == nil){
            createAlert(title:"카메라를 불러올 수 없음",message:"카메라를 불러오는데 오류가 존재합니다.\n권한을 확인해 주세요.")
            return
        }
        
        do {
            // Create an instance of the AVCaptureDeviceInput class using the device object and intialise capture session
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session = AVCaptureSession()
            session?.addInput(input)
            // Initialize the video preview layer and add it as a sublayer to the viewcontroller view's layer.

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = cameraLayer.layer.bounds
            cameraLayer.layer.addSublayer(videoPreviewLayer!)
            
            // Start capture session.
            session?.startRunning()
        } catch {
            // If any error occurs, let the user know. For the example purpose just print out the error
            print(error)
            return
        }
        
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation(rawValue:UIDevice.current.orientation.rawValue)!
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        videoPreviewLayer?.frame = rect
        videoPreviewLayer!.videoGravity =    AVLayerVideoGravity.resizeAspectFill
        
    }
    private func dismissCaptureSession() {
        if let running = self.session?.isRunning, running {
            self.session?.stopRunning()
        }
        self.session = nil
        self.videoPreviewLayer?.removeFromSuperlayer()
        self.videoPreviewLayer = nil
    }
    
    func createAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func roundBtn(_ object:AnyObject){
        object.layer?.cornerRadius = (object.frame?.size.width)!/2;
        object.layer?.masksToBounds = true;
    }
    func squareBtn(_ object:AnyObject){
        object.layer?.cornerRadius = 0;
        object.layer?.masksToBounds = true;
    }
    
    
    func loadEditorView(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Editor", bundle: nil)
        let editorViewController = storyBoard.instantiateViewController(withIdentifier: "editorView") as! EditorViewController
        self.present(editorViewController, animated: false, completion: nil)
    }
    
    func startRecord(){
        
    }
    func stopRecord()
    {
        
    }
    
    
    @IBAction func clickRecordBtn(_ sender: Any) {
        if recoStatus { //정지처리
            recoStatus = false;
            roundBtn(recordBtn)
            self.stopRecord()
            loadEditorView()
        }else{ //녹화처리
            recoStatus = true;
            squareBtn(recordBtn)
            self.startRecord()
            
            
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
