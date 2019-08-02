//동영상에서 썸네일 따와서 갤러리에 출력해주고 출력
//
//  ViewController.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 16/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//


import Photos
import AVFoundation
import MobileCoreServices



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
    let picker = UIImagePickerController()
    var videoURL: NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadImages()
        saveImages()
        picker.delegate = self
        
    }
    var pathData : [URL]!

    func remove(){
        structure.indexNumber.removeAll()
        structure.urlImg.removeAll()
        structure.urlVideo.removeAll()
        
    }
    
    func loadImages(){
        do {
            // contentsOfDirectory(atPath:)가 해당 디렉토리 안의 파일 리스트를 배열로 반환
            //let contents = try filemanager.contentsOfDirectory(atPath: "\(document)")
            let contents = try filemanager.contentsOfDirectory(at: document, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions(rawValue: FileManager.DirectoryEnumerationOptions.RawValue(VOL_CAP_FMT_HIDDEN_FILES)))
            pathData = contents
            print(pathData.count)
        } catch let error as NSError {
            print("Error access directory: \(error)")
        }
    }
    
    
    func saveImages() {
        var number = 0
        var loadNumber = 0
        
        print(document)
        
        for _ in 0...pathData.count {
            if pathData.count != 1 {
                //모든 app의 표준 폴더인 document 폴더를 가지고 온다는 뜻

                let imgUrl : URL = pathData[number]
                
                
                //모든 내용이 저장된 데이터베이스 폴더를 가리키는 경로를 구축한다는 뜻.(폴더 안에 해당파일 가르키기)
                //print(imgUrl.path)
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
    
    
    @IBOutlet weak var addBtn: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func removeImage(indx: Int) {
        print(indx)
        print(structure.urlVideo[indx])
        let deleteUrl : URL = structure.urlVideo[indx]
        
        try? FileManager.default.removeItem(at: deleteUrl)
        
        structure.urlImg.remove(at: indx)
        structure.urlVideo.remove(at: indx)
        structure.indexNumber.remove(at: indx)
        

    }
    
    func loadRecordView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Record", bundle: nil)
        let recordViewController = storyBoard.instantiateViewController(withIdentifier: "recordView") as! RecordViewController
        self.present(recordViewController, animated: true, completion: nil)
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
    
    @IBAction func clickAddBtn(_ sender: Any) {
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
            self.loadRecordView()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
        loadRecordView()
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




extension MainViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        
        if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
            
    
        videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! NSURL)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Record", bundle: nil)
        let recordViewController = storyBoard.instantiateViewController(withIdentifier: "recordView") as! RecordViewController
        recordViewController.loadEditorView(fileURL: videoURL)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
