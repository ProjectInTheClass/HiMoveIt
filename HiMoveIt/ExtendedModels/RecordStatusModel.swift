//
//  RecordStatusModel.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 23/07/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import Foundation


class RecordStatusModel{
    var recordOn:Bool?
    var flashOn:Bool?
    var filterNum:Int?
    
    
    
    func setRecordOn(status:Bool){
        self.recordOn = status
    }
    
    func setFlashOn(status:Bool){
        self.flashOn = status
    }
    
    func setFilterNum(idx:Int){
        self.filterNum = idx
    }
    
    func getRecordOn() -> Bool{
        return self.recordOn!
    }
    func getFlashOn() -> Bool{
        return self.flashOn!
    }
    func getFilterNum() -> Int{
        return self.filterNum!
    }
    
    init(){
        setRecordOn(status: false)
        setFlashOn(status: false)
        setFilterNum(idx: 0)
    }
    
}
