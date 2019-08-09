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

class MainViewController: UIViewController{

    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var addBtn: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    let cellIdentifier: String = "cell"
    let picker = UIImagePickerController()
    var videoURL: NSURL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImages()
        //saveImages()
        picker.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    
    var gridData : [URL]!
    
    func loadImages(){
        do {
            var loadNumber = 0
            let contents = try filemanager.contentsOfDirectory(at: document, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions(rawValue: FileManager.DirectoryEnumerationOptions.RawValue(VOL_CAP_FMT_HIDDEN_FILES)))
            contents.forEach { (url) in
                let lastName : String = url.lastPathComponent
                if lastName == ".DS_Store"{
                } else{
                    if url.absoluteString.contains("png"){
                        gridData.append(url)
                    }
                    loadNumber += 1
                }
                
            }
            //print(pathData.count)
        } catch let error as NSError {
            print("Error access directory: \(error)")
        }
    }
    
    func loadRecordView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Record", bundle: nil)
        let recordViewController = storyBoard.instantiateViewController(withIdentifier: "recordView") as! RecordViewController
        self.present(recordViewController, animated: true, completion: nil)
    }

    @IBAction func clickAddBtn(_ sender: Any) {
        let alert =  UIAlertController(title: "영상 소스 선택", message: "원하는 방법으로 영상 소스를 불러와 주세요", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary() }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in self.loadRecordView() }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
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
    func loadPreview(gifUrl:URL){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Preview", bundle: nil)
        let previewController = storyBoard.instantiateViewController(withIdentifier: "preview") as! PreviewController
        previewController.setGifUrl(url: gifUrl)
        self.present(previewController, animated: true, completion: nil)
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
    var gifURL:String?
    func setGifUrl(gifURL:String){
        self.gifURL = gifURL
    }
    
}
//extiension
extension MainViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCellModel
        cell.imageEx.image =  UIImage(contentsOfFile: gridData[indexPath.row].absoluteString)
        cell.gifURL = gridData[indexPath.row].absoluteString.replacingOccurrences(of: "png", with: "gif")
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ImageCollectionViewCellModel
        let gifUrl = NSURL(fileURLWithPath: cell.gifURL!)
        
        
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
            NextStapFunc(fileURL: videoURL!)
        }

        dismiss(animated: true, completion: nil)

    }

}

