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

class MainViewController: UIViewController{
    
    let cellIdentifier: String = "cell"
    var arrImage = ["01.mov","02.mov","20.mov","21.mov","22.mov","23.mov","24.mov"]

    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveImages()
        
    }
struct urlAndImage
{
    var urlImg = [UIImage]()
    var urlVideo = [URL]()
    }
    
    var structure = urlAndImage()
    
    func saveImages() {
        
        for imgStr in 	{
            let document = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            //모든 app의 표준 폴더인 document 폴더를 가지고 온다는 뜻
            //print(document)
            let imgUrl: URL = document.appendingPathComponent(imgStr,isDirectory: true)
            //모든 내용이 저장된 데이터베이스 폴더를 가리키는 경로를 구축합니다.(폴더 안에 해당파일 가르키기)
            //print(imgUrl.path)
            let thumbnail : UIImage = self.imgFromVideo(url: imgUrl, at: 8)!
            
           structure.urlImg.append(thumbnail)
           structure.urlVideo.append(imgUrl)
        }
        
    }
    
    func imgFromVideo(url: URL, at time: TimeInterval) -> UIImage? {
        let assetUrl = AVURLAsset(url: url)
        
        let assetImg = AVAssetImageGenerator(asset: assetUrl)
        assetImg.appliesPreferredTrackTransform = true
        assetImg.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        
        let cmTime = CMTime(seconds: time, preferredTimescale: 10)
        let thumbnailImg: CGImage
        do {
            thumbnailImg = try assetImg.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }
        
        return UIImage(cgImage: thumbnailImg)
    }
    
    
    @IBOutlet weak var addBtn: UIButton!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func loadRecordView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Record", bundle: nil)
        let recordViewController = storyBoard.instantiateViewController(withIdentifier: "recordView") as! RecordViewController
        self.present(recordViewController, animated: true, completion: nil)
    }
    
    func loadPreview(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Preview", bundle: nil)
        let previewController = storyBoard.instantiateViewController(withIdentifier: "preview") as! PreviewController
        self.present(previewController, animated: true, completion: nil)
    }
    
    func loadPreview(cellImage:UIImage, cellVideo:URL){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Preview", bundle: nil)
        let previewController = storyBoard.instantiateViewController(withIdentifier: "preview") as! PreviewController
        previewController.setImage(image: cellImage,url: cellVideo)
        self.present(previewController, animated: true, completion: nil)
    }
    
    
    @IBAction func clickTestButton(_ sender: Any) {
        loadPreview()
    }
    //
    
    @IBAction func clickAddBtn(_ sender: Any) {
        loadRecordView()
    }
    
    
}


//collectionviewcell
class ImageCollectionViewCellModel: UICollectionViewCell {
    @IBOutlet var imageEx: UIImageView!
    
}


//extiension
extension MainViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return structure.urlImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCellModel //dowm size casting
        
        cell.imageEx.image = structure.urlImg[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewCellWithd = collectionView.frame.width / 3 - 1
        return CGSize(width: collectionViewCellWithd, height: collectionViewCellWithd)
    } //size
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }//up down
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellImage:UIImage = (collectionView.cellForItem(at: indexPath) as! ImageCollectionViewCellModel).imageEx.image!
        let cellVideo:URL = structure.urlVideo[indexPath.row]
 
        self.loadPreview(cellImage: cellImage,cellVideo: cellVideo)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }//side
}

