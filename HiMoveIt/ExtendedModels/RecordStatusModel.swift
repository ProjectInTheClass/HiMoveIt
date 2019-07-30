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
    var camFront:Bool?
    
    
    
    func setRecordOn(status:Bool){
        self.recordOn = status
    }
    
    func setFlashOn(status:Bool){
        self.flashOn = status
    }
    
    func setFilterNum(idx:Int){
        self.filterNum = idx
    }
    func setCamIsFront(stauts:Bool){
        self.camFront = stauts
    }
    func isRecordOn() -> Bool{
        return self.recordOn!
    }
    func isFlashOn() -> Bool{
        return self.flashOn!
    }
    func getFilterNum() -> Int{
        return self.filterNum!
    }
    func isCamFront() -> Bool{
        return self.camFront!
    }
    
    init(){
        setRecordOn(status: false)
        setFlashOn(status: false)
        setCamIsFront(stauts: false)
        setFilterNum(idx: 0)
    }
    
}
