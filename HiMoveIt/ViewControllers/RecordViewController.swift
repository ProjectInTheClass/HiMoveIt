//
//  RecordViewController.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 19/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var recoStatus:Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.roundBtn(recordBtn);
        // Do any additional setup after loading the view.
    }
    
    func roundBtn(_ object:AnyObject){
        object.layer?.cornerRadius = (object.frame?.size.width)!/2;
        object.layer?.masksToBounds = true;
    }
    func squareBtn(_ object:AnyObject){
        object.layer?.cornerRadius = 0;
        object.layer?.masksToBounds = true;
    }
    
    
    func loadEditorView(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Editor", bundle: nil)
        let editorViewController = storyBoard.instantiateViewController(withIdentifier: "editorView") as! EditorViewController
        self.present(editorViewController, animated: false, completion: nil)
    }
    
    @IBAction func clickRecordBtn(_ sender: Any) {
        if recoStatus {
            recoStatus = false;
            roundBtn(recordBtn)
            loadEditorView()
        }else{
            recoStatus = true;
            squareBtn(recordBtn)
            
            
        }
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
