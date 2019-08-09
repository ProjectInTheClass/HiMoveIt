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

        //loadImages()
        //saveImages()
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
            var loadNumber = 0
            let contents = try filemanager.contentsOfDirectory(at: document, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions(rawValue: FileManager.DirectoryEnumerationOptions.RawValue(VOL_CAP_FMT_HIDDEN_FILES)))
            pathData = contents
            pathData.forEach { (url) in
                let lastName : String = url.lastPathComponent
                if lastName == ".DS_Store"{
                } else{
                    let thumbnail : UIImage = self.imgFromVideo(url: url, at: 8)!
                    structure.urlImg.append(thumbnail)
                    structure.urlVideo.append(url)
                    structure.indexNumber.append(loadNumber)
                    loadNumber += 1
                }
                
            }
            //print(pathData.count)
        } catch let error as NSError {
            print("Error access directory: \(error)")
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
  // 합치기 전에 지우자
    func loadPreview(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Preview", bundle: nil)
        let previewController = storyBoard.instantiateViewController(withIdentifier: "preview") as! PreviewController
        self.present(previewController, animated: true, completion: nil)
    }
    
    @IBAction func clickPreviewButton(_ sender: Any) {
        loadPreview()
    }
    //
    
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
    func loadEditorView(asset:AVAsset){
        //setSwipeTransition()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Editor", bundle: nil)
        let selectorViewController = storyBoard.instantiateViewController(withIdentifier: "selectorView") as! SelectorViewController
        selectorViewController.setAsset(asset: asset)
        self.present(selectorViewController, animated: true, completion: nil)
    }
    func NextStapFunc(fileURL:NSURL){
        let playAsset = AVAsset(url: fileURL as URL)
        
        playAsset.loadValuesAsynchronously(forKeys:["playable"] , completionHandler: {
            var err:NSError? = nil
            let status = playAsset.statusOfValue(forKey: "playable", error: &err)
            
            switch status {
            case .loaded:
                self.loadEditorView(asset: playAsset)
                break
            case .failed:
                print("error:",err as Any)
                break
            default:
                print("error:",err as Any)
                break
            }
        })
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
            NextStapFunc(fileURL: videoURL)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}

