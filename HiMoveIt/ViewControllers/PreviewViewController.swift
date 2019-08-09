//

import UIKit
import AVFoundation
import AVKit
import Photos

class PreviewController: UIViewController {
    
    @IBOutlet weak var preViewImage: UIImageView!
    
    var shareImage = URL(fileURLWithPath: Bundle.main.path(forResource: "image", ofType: "gif") ?? "") // 수정후 지우자 !!
    var image: UIImage = UIImage()
    var imageUrl: URL!
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidAppear(true)
        // Do any additional setup after loading the view.
    }

    func setImage(image: UIImage, url: URL,number: Int){
        self.image = image
        self.imageUrl = url
        self.index = number
    }
    
    override func viewDidAppear(_ animated: Bool) {
        preViewImage.loadGif(name: "testImage") // \(imageUrl) 이걸로 나중에 변경 !!
    }
    
    func loadMainView(){
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyBoard.instantiateViewController(withIdentifier: "main") as! MainViewController
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnShare(_ sender: Any) {

        let vc = UIActivityViewController(activityItems: [shareImage], applicationActivities: []) // share 이놈 image로 변경!!

        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        loadMainView()
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



