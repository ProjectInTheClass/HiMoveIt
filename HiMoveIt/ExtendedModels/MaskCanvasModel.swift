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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        context.setLineWidth(20)
        context.setStrokeColor(UIColor.white.cgColor)
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

extension UIView {
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func toImage() -> UIImage {
        backgroundColor = UIColor(white: 0, alpha: 1.0)
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
            self.isHidden = true
        }
    }
}
