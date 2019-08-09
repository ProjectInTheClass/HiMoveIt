//
//  MaskViewController.swift
//  HiMoveIt
//
//  Created by GW_09 on 07/08/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit
import AVKit
class MaskViewController: UIViewController {
    var selectedImage:UIImage?
    var asset:AVAsset?
    var maskCanvas:MaskCanvasModel?
    @IBOutlet weak var maskLayer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func initSet(asset:AVAsset,image:UIImage){
        self.selectedImage = image
        self.asset = asset
    }
    
    func imageOver(image:UIImage){
        let imageView = UIImageView(image:image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = maskLayer.bounds
        maskLayer.addSubview(imageView)
    }
    func maskOver(){
        maskCanvas = MaskCanvasModel()
        maskCanvas!.frame = maskLayer.bounds
        
        let xBound:CGFloat?
        let yBound:CGFloat?
        if( (selectedImage?.size.width)! < (selectedImage?.size.height)! ){
            xBound = maskLayer.bounds.width
            yBound = maskLayer.bounds.width * ((selectedImage?.size.height)! / (selectedImage?.size.width)!)
        }else{
            xBound = maskLayer.bounds.height  * ((selectedImage?.size.width)! / (selectedImage?.size.height)!)
            yBound = maskLayer.bounds.height
        }
        
        
        maskCanvas!.bounds = CGRect(x: 0, y: 0, width: xBound!, height: yBound!)
        maskCanvas!.contentMode = .scaleAspectFill
        maskCanvas!.backgroundColor = UIColor(white: 1, alpha: 0.3)
        maskLayer.addSubview(maskCanvas!)
    }
    func myimage() -> CGImage?{
        
        //let myimage = #imageLiteral(resourceName: "a").cgImage
        
        let myimage = self.selectedImage?.cgImage
        
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
    
    func loadEditorView(image:CGImage){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Editor", bundle: nil)
        let editorViewController = storyBoard.instantiateViewController(withIdentifier: "editView") as! EditorViewController
        editorViewController.initSet(asset: asset!, maskedImage: image)
        self.present(editorViewController, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.resetLayers()
    }
    
    @IBAction func clickDoneBtn(_ sender: Any) {
        loadEditorView(image: self.myimage()!)
        
    }
    @IBAction func clickCancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clickRestBtn(_ sender: Any) {
        self.resetLayers()
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
