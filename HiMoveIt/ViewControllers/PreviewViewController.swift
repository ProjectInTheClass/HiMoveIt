//

import UIKit
import AVFoundation
import AVKit
import Photos

class PreviewController: UIViewController {
    
    @IBOutlet weak var preViewImage: UIImageView?
    
    var shareImage:NSURL?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDidAppear(true)
        // Do any additional setup after loading the view.
    }

    func setGifUrl(gifUrl: NSURL){
        self.shareImage = gifUrl
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    override func viewDidAppear(_ animated: Bool) {
        //preViewImage!.loadGif(name: "testImage") // \(imageUrl) 이걸로 나중에 변경 !!
        preViewImage!.loadGif(url: shareImage!.absoluteString!)
//        getData(from: shareImage! as URL) { data, response, error in
//            guard let data = data, error == nil else { return }
//            DispatchQueue.global().async {
//                let image = self.preViewImage?.image.gif(data: data)
//                DispatchQueue.main.async {
//                    self.preViewImage?.image = image
//                }
//            }
//
//        }
    }
    
    
    @IBAction func btnShare(_ sender: Any) {

        let vc = UIActivityViewController(activityItems: [shareImage as Any], applicationActivities: []) // share 이놈 image로 변경!!

        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func btnDelete(_ sender: Any) {
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}



