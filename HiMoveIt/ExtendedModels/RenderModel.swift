//
//  RenderModel.swift
//  HiMoveIt
//
//  Created by Jaewan Jeong on 09/08/2019.
//  Copyright © 2019 jwmsg. All rights reserved.
//

import Foundation
import AVKit
import MobileCoreServices

class RenderModel{
    var asset:AVAsset?
    var maskedImage:CGImage?
    var frameCount:Int?
    var increment:Float?
    var delayTime:Float?
    var frameRate:Int?
    var rootView:UIViewController?
    private struct Group {
        let group = DispatchGroup()
        func enter() { group.enter() }
        func leave() { group.leave() }
        func wait() { let _ = group.wait(timeout: DispatchTime.distantFuture) }
    }

    
    init(asset:AVAsset, maskedImage:CGImage,rootView:UIViewController){
        self.asset = asset
        self.maskedImage = maskedImage
        self.rootView = rootView
        self.frameRate = 15
        self.frameCount = Int(asset.duration.seconds) * frameRate!
        self.increment = Float(Int(asset.duration.seconds)) / Float(frameCount!)
        self.delayTime  = 1.0/Float(frameRate!)
        
    }
    
    func getFileUrl(ext:String) -> [NSURL]{
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyyMMddHHmmss"
        dateFormatter.timeZone = NSTimeZone.local
        
        let filename = dateFormatter.string(from: NSDate() as Date)
        let dirURL:NSURL = NSURL(fileURLWithPath: documentPath!)
        let fileURL:NSURL = dirURL.appendingPathComponent(filename+"."+ext)! as NSURL
        let thmURL:NSURL = dirURL.appendingPathComponent(filename+".png")! as NSURL
        return [fileURL,thmURL]
    }
    func imageMerge(baseImage:UIImage, overImage:UIImage) -> CGImage?{
        let bounds1 = CGRect(x: 0, y: 0, width: baseImage.size.width, height: baseImage.size.height)
        let bounds2 = CGRect(x: 0, y: 0, width: overImage.size.width, height: overImage.size.height)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let ctx = CGContext(data: nil,
                            width: baseImage.cgImage!.width,
                            height: baseImage.cgImage!.height,
                            bitsPerComponent: baseImage.cgImage!.bitsPerComponent,
                            bytesPerRow: baseImage.cgImage!.bytesPerRow,
                            space: baseImage.cgImage!.colorSpace!,
                            bitmapInfo: bitmapInfo.rawValue)!
        ctx.draw(baseImage.cgImage!, in: bounds1)
        ctx.setBlendMode(.normal)
        ctx.draw(overImage.cgImage!, in: bounds2)
        return ctx.makeImage()
    }
    
    
    
    func render(alerter:UIAlertController) -> NSURL?{
        guard asset != nil else{
            return nil
        }
        guard maskedImage != nil else {
            return nil
        }
        
        var timePoints:[CMTime] = []
        var handledTimes: Int = 0
        
        
        let fileProperties = [kCGImagePropertyGIFDictionary as String:[
            kCGImagePropertyGIFLoopCount as String: NSNumber(value: Int32(0) as Int32)],
                              kCGImagePropertyGIFHasGlobalColorMap as String: NSValue(nonretainedObject: true)
            ] as [String : Any]
        
        let frameProperties = [
            kCGImagePropertyGIFDictionary as String:[
                kCGImagePropertyGIFDelayTime as String:delayTime
            ]
        ]
        
        for frameNumber in 0 ..< frameCount! {
            let seconds: Float64 = Float64(0) + (Float64(increment!) * Float64(frameNumber))
            let time = CMTimeMakeWithSeconds(seconds, preferredTimescale: (asset?.duration.timescale)!)
            timePoints.append(time)
        }
        let generator = AVAssetImageGenerator(asset: asset!)
        
        generator.requestedTimeToleranceBefore = CMTime.zero
        generator.requestedTimeToleranceAfter = CMTime.zero
        
        generator.appliesPreferredTrackTransform = true
        var times = [NSValue]()
        for time in timePoints {
            times.append(NSValue(time: time))
        }
        
        
        let gifGroup = Group()
        gifGroup.enter()
        
        
        let fileUrl = self.getFileUrl(ext: "gif")
        guard let destination = CGImageDestinationCreateWithURL(fileUrl[0] as CFURL, kUTTypeGIF, frameCount!, nil) else {
            return nil
        }

        
        generator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { (requestedTime, image, actualTime, result, error) in
            handledTimes += 1
            
            guard let imageRef = image , error == nil else {
                if requestedTime == times.last?.timeValue {
                    alerter.dismiss(animated: true, completion: nil)
                    FloatAlertModel(rootView: self.rootView!).createAlert(title: "생성완료", message: "성공적으로 생성되었습니다.")
                    gifGroup.leave()
                }
                return
            }
            
            

            let maskImage = UIImage(cgImage: self.maskedImage!)
            let baseImage = UIImage(cgImage: imageRef)
            let newImage = self.imageMerge(baseImage: baseImage, overImage: maskImage)
            if(handledTimes == 1){
                self.saveImage(image: newImage!,url: fileUrl[1])
            }
            CGImageDestinationAddImage(destination, newImage!, frameProperties as CFDictionary)
            if requestedTime == times.last?.timeValue {
                alerter.dismiss(animated: true, completion: nil)
                FloatAlertModel(rootView: self.rootView!).createAlert(title: "생성완료", message: "성공적으로 생성되었습니다.")
                gifGroup.leave()
            }
        })
        gifGroup.wait()
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
        CGImageDestinationFinalize(destination)
        
        return fileUrl[0]
    }
    func imageWith(uiImage: UIImage,rate:CGFloat) -> UIImage {
        let bounds1 = CGRect(x: 0, y: 0, width: uiImage.size.width * rate, height: uiImage.size.height * rate)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        let ctx = CGContext(data: nil,
                            width: Int(CGFloat(uiImage.cgImage!.width) * rate),
                            height: Int(CGFloat(uiImage.cgImage!.height) * rate),
                            bitsPerComponent: uiImage.cgImage!.bitsPerComponent,
                            bytesPerRow: uiImage.cgImage!.bytesPerRow,
                            space: uiImage.cgImage!.colorSpace!,
                            bitmapInfo: bitmapInfo.rawValue)!
        ctx.draw(uiImage.cgImage!, in: bounds1)
        let outUIImage = UIImage(cgImage: ctx.makeImage()!)
        return outUIImage
    }
    func saveImage (image: CGImage, url: NSURL ){
        let uiImage = imageWith(uiImage: UIImage(cgImage: image),rate:0.5)
        let pngImageData = uiImage.pngData()
        try! pngImageData!.write(to: url as URL)
    }
    
}

