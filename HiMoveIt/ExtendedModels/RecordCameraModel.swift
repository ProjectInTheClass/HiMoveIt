//
//  RecordCameraModel.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 23/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class RecordCameraModel{
    var session: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice:AVCaptureDevice?
    var movieOutput: AVCaptureMovieFileOutput?
    
    
    var cameraLayer: UIView?
    var rootView:UIViewController?
    
    var outFileDir:NSURL?
    
    func setCamera(){
        if(captureDevice == nil){
            FloatAlertModel(rootView: rootView!).createAlert(title:"카메라를 불러올 수 없음",message:"카메라를 불러오는데 오류가 존재합니다.\n권한을 확인해 주세요.")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            session = AVCaptureSession()
            session?.addInput(input)
            
            
            movieOutput = AVCaptureMovieFileOutput()
            session?.addOutput(movieOutput!)
            let videoConn = movieOutput!.connection(with: AVMediaType.video)
            if(videoConn!.isVideoMirroringSupported){
                videoConn?.videoOrientation = AVCaptureVideoOrientation(rawValue:UIDevice.current.orientation.rawValue)!
            }
            
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = cameraLayer!.layer.bounds
            cameraLayer!.layer.addSublayer(videoPreviewLayer!)
            
            
            session?.startRunning()
        } catch {
            print(error)
            return
        }
        
    }
    
    
    func startRec(){
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyyMMddHHmmss"
        dateFormatter.timeZone = NSTimeZone.local
        
        let filename = dateFormatter.string(from: NSDate() as Date)
        let dirURL:NSURL = NSURL(fileURLWithPath: documentPath!)
        let fileURL:NSURL = dirURL.appendingPathComponent(filename+".mp4")! as NSURL
        movieOutput?.startRecording(to: fileURL as URL, recordingDelegate: rootView as! AVCaptureFileOutputRecordingDelegate)
        outFileDir = fileURL
    }
    
    func stopRec() -> NSURL{
        movieOutput?.stopRecording()
        return self.outFileDir!
    }
    
    private func dismissCaptureSession() {
        if let running = self.session?.isRunning, running {
            self.session?.stopRunning()
        }
        self.session = nil
        self.videoPreviewLayer?.removeFromSuperlayer()
        self.videoPreviewLayer = nil
    }
    
    func onFlash(){
        if captureDevice!.hasTorch{
            do {
                try captureDevice?.lockForConfiguration()
                captureDevice?.torchMode = .on
                captureDevice?.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
    func offFlash(){
        if captureDevice!.hasTorch{
            do {
                try captureDevice?.lockForConfiguration()
                captureDevice?.torchMode = .off
                captureDevice?.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
    func firstSetCam(){
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back )
        {
            captureDevice = device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back )
        {
            captureDevice = device
        } else{
            print("Back Cam is disable")
            return
        }
    }
    func frontCam(){
        //captureDevice = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaType.video) && $0.position == .front }.first!
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .front )
        {
            captureDevice = device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .front )
        {
            captureDevice = device
        } else{
            print("Front Cam is disable")
            return
        }
        setCamera()
        
    }
    func backCam(){
        //captureDevice = AVCaptureDevice.devices().filter{ $0.hasMediaType(AVMediaType.video) && $0.position == .front }.first!
        if let device = AVCaptureDevice.default(.builtInDualCamera, for: AVMediaType.video, position: .back )
        {
            captureDevice = device
        } else if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back )
        {
            captureDevice = device
        } else{
            print("Back Cam is disable")
            return
        }
        setCamera()
        
        
    }
    
    
    init(cameraLayer:UIView, rootView:UIViewController) {
        self.cameraLayer = cameraLayer
        self.rootView = rootView
        self.firstSetCam()
    }
    
}
