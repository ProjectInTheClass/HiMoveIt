//

import UIKit
import AVFoundation
import AVKit
import Photos

class PreviewController: UIViewController {
    
    //let text = "공유할 이미지(APNG)에 대한 이름" // 공유할 때 같이 들어가는 텍스트 [ 삭제 가능 ]
    //let URL:NSURL = NSURL(string: "https://www.naver.com")! // 같이 들어가는 URL [ 삭제 가능 ]
    //let image = URL(fileURLWithPath: Bundle.main.path(forResource: "Image", ofType: "png") ?? "") // 일단은 Asset에 있는 예시사진을 넣어두었고, 추후에 넘어온 이미지로 그 대상을 변경시켜줘야함.
    

    
    @IBOutlet weak var preViewImage: UIImageView!
    
    var image: UIImage = UIImage()
    var imageUrl: URL!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let player = AVPlayer(url: imageUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true){
            playerViewController.player?.play()
        }
    }
    
    func setImage(image: UIImage, url: URL,number: Int){
        self.image = image
        self.imageUrl = url
        self.index = number
    }
    
    override func viewDidAppear(_ animated: Bool) {
        preViewImage.image = image
    }
    
    func loadMainView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! MainViewController
        mainViewController.removeImage(indx: index!)
        self.present(mainViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnShare(_ sender: Any) {
        //let videoUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "FastTyping", ofType: "mp4") ?? "")
        // 공유할 때 넘어가는 정보들. 현재는 3가지로 해둠
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        //let activityVC = UIActivityViewController(activityItems: [videoUrl] , applicationActivities: nil)
        //present(vc, animated: true, completion: nil)
        
        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        let player = AVPlayer(url: imageUrl)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true){
            playerViewController.player?.play()
        }
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        loadMainView()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



