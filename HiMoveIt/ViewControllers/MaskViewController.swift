//
//  MaskViewController.swift
//  HiMoveIt
//
//  Created by GW_09 on 07/08/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit

class MaskViewController: UIViewController {
    var selectedImage:UIImage?
    var maskCanvas:MaskCanvasModel?
    var currentImageView:UIImageView?
    var imageRECT:CGRect?
    @IBOutlet weak var maskLayer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetLayers()
        // Do any additional setup after loading the view.
    }
    
    func setSelectedIamge(image:UIImage){
        self.selectedImage = image
    }
    
    func imageOver(image:UIImage){
        let imageView = UIImageView(image:image)
        imageView.contentMode = .scaleAspectFill
        imageRECT = imageView.frame
        imageView.frame = maskLayer.bounds
        maskLayer.clipsToBounds = true;
        maskLayer.addSubview(imageView)
        currentImageView = imageView
    }
    func maskOver(){
        maskCanvas = MaskCanvasModel()
        maskCanvas!.frame = maskLayer.bounds
        let xBound = maskLayer.bounds.width
        let yBound = maskLayer.bounds.width * ((selectedImage?.size.height)! / (selectedImage?.size.width)!)
        maskCanvas!.bounds = CGRect(x: 0, y: 0, width: xBound, height: yBound)
        maskCanvas!.contentMode = .scaleAspectFill
        maskCanvas!.backgroundColor = UIColor(white: 1, alpha: 0.3)
        maskLayer.addSubview(maskCanvas!)
    }
    func myimage() -> CGImage?{
        
        //let myimage = #imageLiteral(resourceName: "a").cgImage
        
        var myimage = self.selectedImage?.cgImage
        
        guard maskCanvas?.rootContext != nil else{
            print("maskCanvas rootContext is null")
            return nil
        }
        
        guard let maskImage = maskCanvas?.toImage().cgImage else{
            return nil
        }
        
        guard let myMask = CGImage(
            maskWidth: maskImage.width,
            height: maskImage.height,
            bitsPerComponent: maskImage.bitsPerComponent,
            bitsPerPixel: maskImage.bitsPerPixel,
            bytesPerRow: maskImage.bytesPerRow,
            provider: maskImage.dataProvider!, decode: nil, shouldInterpolate: false
            ) else{
                return nil
        }
        guard let newImage = myimage!.masking(myMask) else{
            return nil
        }
        maskLayer.subviews.forEach { (myUI) in
            myUI.removeFromSuperview()
        }
        imageOver(image: UIImage(cgImage: newImage))
        return newImage
    }
    
    func resetLayers(){
        maskLayer.subviews.forEach { (myUI) in
            myUI.removeFromSuperview()
        }
        imageOver(image: self.selectedImage!)
        maskOver()
    }
    @IBAction func testbtn(_ sender: Any) {
        myimage()
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func clickCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
