//동영상에서 썸네일 따와서 갤러리에 출력해주고 출력
//
//  ViewController.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 16/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit
import Photos
import AVFoundation
import MobileCoreServices
import Regift



//let document = "/Users/gw_12/Desktop/image"

class MainViewController2: UIViewController{

    let picker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }

    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func loadRecordView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Record", bundle: nil)
        let recordViewController = storyBoard.instantiateViewController(withIdentifier: "recordView") as! RecordViewController
        self.present(recordViewController, animated: true, completion: nil)
    }
    
    func openLibrary()
    {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.allowsEditing = false
            present(picker, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickAddBtn(_ sender: Any) {
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.loadRecordView()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
        self.loadRecordView()
    }
}

extension MainViewController2 : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
            
            
            let videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
            
            /*
             let thumbnail : UIImage = self.imgFromVideo(url: videoURL, at: 8)!
             
             structure.urlImg.append(thumbnail)
             structure.urlVideo.append(videoURL)
             structure.indexNumber.append(loadNumber)
             
             number = number + 1
             loadNumber = loadNumber + 1
             */
            let lastData = videoURL.lastPathComponent
            let newData = document.appendingPathComponent(lastData, isDirectory: true)
            
            
            do {
                try filemanager.moveItem(at: videoURL, to: newData)
            } catch let error {
                print("Failed copying directory, \(error)")
            }
            
            self.viewDidLoad()
            
            
        }
        
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
