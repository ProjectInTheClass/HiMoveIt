//
//  PreviewController.swift
//  HiMoveIt
//
//  Created by KangKyung on 22/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit

class PreviewController: UIViewController {
    
    //let text = "공유할 이미지(mp4?)에 대한 이름" // 공유할 때 같이 들어가는 텍스트 [ 삭제 가능 ]
    //let URL:NSURL = NSURL(string: "https://www.naver.com")! // 같이 들어가는 URL [ 삭제 가능 ]
    //let image = UIImage(named: "Image") // 일단은 Asset에 있는 예시사진을 넣어두었고, 추후에 넘어온 이미지로 그 대상을 변경시켜줘야함.
    
    
    @IBOutlet var preViewImage: UIImageView!
    
    var image: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func setImage(image:UIImage){
        self.image = image
    }
    
    override func viewDidAppear(_ animated: Bool) {
        preViewImage.image = image
    }
    
    @IBAction func btnShare(_ sender: Any) {
        let videoUrl = URL(fileURLWithPath: Bundle.main.path(forResource: "FastTyping", ofType: "mp4") ?? "")
        // 공유할 때 넘어가는 정보들. 현재는 3가지로 해둠
        //let vc = UIActivityViewController(activityItems: [text, image!], applicationActivities: [])
        let activityVC = UIActivityViewController(activityItems: [videoUrl] , applicationActivities: nil)
        //present(vc, animated: true, completion: nil)
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        
        present(activityVC, animated: true, completion: nil)
    }
    
    @IBAction func btnPlay(_ sender: Any) {
        // 해당 이미지를 재생시키는 코드 -> 썸네일
    }
    
    @IBAction func btnDelete(_ sender: Any) {
        // 해당 이미지를 삭제하는 코드
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

