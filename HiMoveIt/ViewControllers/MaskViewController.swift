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
    @IBOutlet weak var maskLayer: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    func setSelectedIamge(image:UIImage){
        self.selectedImage = image
    }
    func imageOver(){
        let imageView = UIImageView(image:selectedImage!)
        imageView.frame = maskLayer.bounds
        imageView.contentMode = .scaleAspectFill
        maskLayer.contentMode = .scaleAspectFill
        maskLayer.clipsToBounds = true;
        maskLayer.addSubview(imageView)
    }
    func maskOver(){
        maskCanvas = MaskCanvasModel()
        maskCanvas!.frame = maskLayer.bounds
        maskCanvas!.backgroundColor = UIColor(white: 1, alpha: 0.2)
        maskLayer.addSubview(maskCanvas!)
    }
    func masktest(){
        
        let myimage = #imageLiteral(resourceName: "a")
        
        guard maskCanvas?.rootContext != nil else{
            print("maskCanvas rootContext is null")
            return
        }
        
        let maskImage = maskCanvas?.rootContext?.makeImage()
        
        let newImage = myimage.cgImage?.masking(maskImage!)
        

        let newUIImage = UIImage(cgImage: newImage!)
        let imageView = UIImageView(image:newUIImage)
        imageView.frame = maskLayer.bounds
        imageView.contentMode = .scaleAspectFill
        maskLayer.contentMode = .scaleAspectFill
        maskLayer.clipsToBounds = true;
        maskLayer.addSubview(imageView)
        
        
        
        
        
        
        
    }
    @IBAction func testbtn(_ sender: Any) {
        masktest()
    }
    override func viewDidAppear(_ animated: Bool) {
        imageOver()
        maskOver()
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
