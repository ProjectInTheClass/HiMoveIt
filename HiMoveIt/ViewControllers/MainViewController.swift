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
    var arrImage = ["1.png","2.png","3.png","4.png","5.png","6.png","7.png","8.png","9.png","10.png","11.png","12.png","13.png","14.png","15.png","16.png","17.png","18.png","19.png"]
    var urlImg = [URL]()
    
    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveImages()
    }
    
    
    func saveImages() {
        
        for imgStr in arrImage{
            let document = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            //document안의 url
            //print(document)
            let imgUrl = document.appendingPathComponent(imgStr,isDirectory: true)
            //document directroy 내로 imgStr image 생성
            //print(imgUrl.path)
            
            if !FileManager.default.fileExists(atPath: imgUrl.path){
                //file안에 img가 존재하는지 확인 해준다
                do{
                    try UIImage(named: imgStr)!.pngData()?.write(to: imgUrl)
                    //print("image add successfully")
                }catch{
                    //print("image not added")
                }
            }
            urlImg.append(imgUrl)
        }
        
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
    
    func loadPreview(cellImage:UIImage){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Preview", bundle: nil)
        let previewController = storyBoard.instantiateViewController(withIdentifier: "preview") as! PreviewController
        previewController.setImage(image: cellImage)
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

class ImageCollectionViewCellModel: UICollectionViewCell {
    @IBOutlet var imageEx: UIImageView!
    
    
}

extension MainViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return urlImg.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCellModel //dowm size casting
        
        cell.imageEx.image = UIImage(contentsOfFile: urlImg[indexPath.row].path)
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
        self.loadPreview(cellImage: cellImage)
    
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }//side
}


