//
//  ViewController.swift
//  ApproachPictureApp
//
//  Created by KangKyung on 01/08/2019.
//  Copyright © 2019 KangKyung. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController{
    
    let picker = UIImagePickerController()
    var videoURL: URL!
    
    var flagImageSave = false
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
    }
    
    @IBAction func addAction(_ sender: Any) {
        let alert =  UIAlertController(title: "원하는 타이틀", message: "원하는 메세지", preferredStyle: .actionSheet)
        
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        //빼도댐
        /*
        let camera =  UIAlertAction(title: "동영상 촬영", style: .default) { (action) in
            self.openCamera()
        }
        */
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
            self.openCamera()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
    }
    
    func openLibrary()
    {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            flagImageSave = false
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.mediaTypes = [kUTTypeMovie as String]
            picker.allowsEditing = false
            present(picker, animated: true, completion: nil)
        }
    }
    func openCamera()
    {
        /*
         recordview 가 열리도록 한다
         
         */
        //빼도댐
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            present(picker, animated: false, completion: nil)
        }
        else{
            print("Camera not available")
        }
        }
    
    }

extension ViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
            
            if flagImageSave == false {
                //촬영한 비디오를 포토 라이브러리에 저장
                videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL)
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
                
            }
            
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    //
    //    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    //        dismiss(animated: true, completion: nil)
    //    }
    
}
