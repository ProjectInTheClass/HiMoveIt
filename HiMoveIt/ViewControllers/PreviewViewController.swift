//
//  PreviewController.swift
//  HiMoveIt
//
//  Created by KangKyung on 22/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit
import Regift

class PreviewController: UIViewController {
    
    //let text = "공유할 이미지(APNG)에 대한 이름" // 공유할 때 같이 들어가는 텍스트 [ 삭제 가능 ]
    //let URL:NSURL = NSURL(string: "https://www.naver.com")! // 같이 들어가는 URL [ 삭제 가능 ]
    let image = URL(fileURLWithPath: Bundle.main.path(forResource: "Image", ofType: "gif") ?? "") // 일단은 Asset에 있는 예시사진을 넣어두었고, 추후에 넘어온 이미지로 그 대상을 변경시켜줘야함.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
//    // gif 파일로 변환하는 코드. 이후 함수하나 추가해서 넣어주면 됨.
//    // Do any additional setup after loading the view.
//    let document = try!FileManager.default.url(for: . documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//    //print(document)
//
//    let path: URL = document.appendingPathComponent("FastTyping.mp4", isDirectory: true) // 동영상이 있는 디렉토리에서 파일을 가져옴
//
//    let frameCount = 16
//    let delayTime  = Float(0.2)
//    let loopCount  = 0    // 0 means loop forever
//
//    let regift = Regift(sourceFileURL: path, frameCount: frameCount, delayTime: delayTime, loopCount: loopCount)
//    print("Gif saved to \(regift.createGif())")
    
    @IBAction func btnShare(_ sender: Any) {
        // 공유할 때 넘어가는 정보
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: []) // text, URL,
        
        if let popoverController = vc.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
        }
        
        self.present(vc, animated: true, completion: nil)
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
