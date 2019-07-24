//
//  ViewController.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 16/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//	

import UIKit
import Photos

class MainViewController: UIViewController{
    @IBOutlet weak var addBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func loadRecordView(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Record", bundle: nil)
        let recordViewController = storyBoard.instantiateViewController(withIdentifier: "recordView") as! RecordViewController
        self.present(recordViewController, animated: true, completion: nil)
    }
    func loadPreview(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Preview", bundle: nil)
        let previewController = storyBoard.instantiateViewController(withIdentifier: "preview") as! PreviewController
        self.present(previewController, animated: true, completion: nil)
    }

    @IBAction func clickTestButton(_ sender: Any) {
        loadPreview()
    }
    //
    
    @IBAction func clickAddBtn(_ sender: Any) {
        loadRecordView()
    }

    
    
}
