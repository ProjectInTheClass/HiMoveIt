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


let filemanager = FileManager()
let document = try! filemanager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//let document = "/Users/gw_12/Desktop/image"

struct UrlAndImage
{
    var urlImg = [UIImage]()
    var urlVideo = [URL]()
    var indexNumber = [Int]()
}

var structure = UrlAndImage()


class MainViewController: UIViewController{
    
    let cellIdentifier: String = "cell"
    @IBOutlet var collectionView: UICollectionView!

    var videoURL: URL!
    
    var number = 0
    var loadNumber = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(document)
        loadImages()
        saveImages()
 
        
    }
    var pathData : [URL]!
    
    func remove(){
        structure.indexNumber.removeAll()
        structure.urlImg.removeAll()
        structure.urlVideo.removeAll()
        
    }
    
    func loadImages(){
        do {
            let contents = try filemanager.contentsOfDirectory(at: document, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions(rawValue: FileManager.DirectoryEnumerationOptions.RawValue(VOL_CAP_FMT_HIDDEN_FILES)))
            pathData = contents
        } catch let error as NSError {
            print("Error access directory: \(error)")
        }
    }
    
    
    func saveImages() {
        
        
        for _ in 0...pathData.count-1{
            if pathData.count != 0 {
                
                let imgUrl : URL = pathData[number]
                
                let lastName : String = imgUrl.lastPathComponent
                if lastName == ".DS_Store"{
                    number = number + 1
                    continue
                }
                let thumbnail : UIImage = self.imgFromVideo(url: imgUrl, at: 8)!
                
                structure.urlImg.append(thumbnail)
                structure.urlVideo.append(imgUrl)
                structure.indexNumber.append(loadNumber)
                
                
                number = number + 1
                loadNumber = loadNumber + 1
                
            }
            else  {
                break
            }
        }
        
    }
    
    func imgFromVideo(url: URL, at time: TimeInterval) -> UIImage? {
        let assetUrl = AVURLAsset(url: url)
        
        let assetImg = AVAssetImageGenerator(asset: assetUrl)
        assetImg.appliesPreferredTrackTransform = true
        assetImg.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
        
        let cmTime = CMTime(seconds: time, preferredTimescale: 60)
        let thumbnailImg: CGImage
        do {
            thumbnailImg = try assetImg.copyCGImage(at: cmTime, actualTime: nil)
        } catch let error {
            print("Error: \(error)")
            return nil
        }
        
        return UIImage(cgImage: thumbnailImg)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func removeImage(indx: Int) {
        print(indx)
        
        print(structure.urlVideo[indx])
        let deleteUrl : URL = structure.urlVideo[indx]
        
        try? FileManager.default.removeItem(at: deleteUrl)
        
        
        structure.urlImg.removeAll()
        structure.urlVideo.removeAll()
        structure.indexNumber.removeAll()
        
        
        number = 0
        loadNumber = 0
        
        self.viewDidLoad()
    }
    

    func loadPreview(cellImage:UIImage, cellVideo:URL, cellNumber:Int){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Preview", bundle: nil)
        let previewController = storyBoard.instantiateViewController(withIdentifier: "preview") as! PreviewController
        previewController.setImage(image: cellImage,url: cellVideo,number: cellNumber)
        self.present(previewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    
}



//collectionviewcell
class ImageCollectionViewCellModel: UICollectionViewCell {
    
    @IBOutlet weak var imageEx: UIImageView!
    
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
        let cellNumber:Int = structure.indexNumber[indexPath.row]
        
        self.loadPreview(cellImage: cellImage,cellVideo: cellVideo,cellNumber: cellNumber)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }//side
}



