//
//  FloatAlertModel.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 23/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import Foundation
import UIKit

class FloatAlertModel{
    var rootView:UIViewController?
    
    func createAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            self.rootView?.navigationController?.popViewController(animated: true)
        }))
        self.rootView!.present(alert, animated: true, completion: nil)
    }
    
    func createAlert(title:String,message:String,funcd:@escaping () -> ()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            funcd()
            self.rootView?.navigationController?.popViewController(animated: true)
        }))
        self.rootView!.present(alert, animated: true, completion: nil)
    }
    
    init(rootView:UIViewController) {
        self.rootView = rootView
    }
}
