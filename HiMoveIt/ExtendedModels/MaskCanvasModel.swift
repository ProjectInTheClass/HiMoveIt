//
//  MaskCanvasModel.swift
//  HiMoveIt
//
//  Created by GW_09 on 07/08/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import UIKit

class MaskCanvasModel: UIView {
    var line = [CGPoint]()
    var lines = [[CGPoint]]()
    var rootContext:CGContext?
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineWidth(20)
        context.setLineCap(.round)
        lines.forEach{(line) in
            for (i,p)in line.enumerated(){
                if(i == 0){
                context.move(to: p)
                } else{
                context.addLine(to: p)
                }
            }
        }
        context.strokePath()
        rootContext = context
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       lines.append([CGPoint]())
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else{
            return
        }
        guard var lastLine = lines.popLast() else{
            return
        }
        lastLine.append( point)
        lines.append(lastLine)
        setNeedsDisplay()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
