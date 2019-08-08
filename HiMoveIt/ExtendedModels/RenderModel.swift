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
    
    private struct Group {
        let group = DispatchGroup()
        func enter() { group.enter() }
        func leave() { group.leave() }
        func wait() { let _ = group.wait(timeout: DispatchTime.distantFuture) }
    }

    
    init(asset:AVAsset, maskedImage:CGImage){
        self.asset = asset
        self.maskedImage = maskedImage
        self.frameCount = Int(asset.duration.seconds) * 24
        self.increment = Float(Int(asset.duration.seconds)) / Float(frameCount!)
        self.delayTime  = 1.0/24
        
    }
    
    func getFileUrl() -> NSURL{
        let documentPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as String?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat="yyyyMMddHHmmss"
        dateFormatter.timeZone = NSTimeZone.local
        
        let filename = dateFormatter.string(from: NSDate() as Date)
        let dirURL:NSURL = NSURL(fileURLWithPath: documentPath!)
        let fileURL:NSURL = dirURL.appendingPathComponent(filename+".gif")! as NSURL
        return fileURL
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
    func render() -> NSURL?{
        guard asset != nil else{
            return nil
        }
        guard maskedImage != nil else {
            return nil
        }
        
        var timePoints:[CMTime] = []
        
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
        
        var handledTimes: Double = 0
        let fileUrl = self.getFileUrl()
        guard let destination = CGImageDestinationCreateWithURL(fileUrl as CFURL, kUTTypeGIF, frameCount!, nil) else {
            return nil
        }
       
        generator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { (requestedTime, image, actualTime, result, error) in
            handledTimes += 1
            guard let imageRef = image , error == nil else {
                if requestedTime == times.last?.timeValue {
                    gifGroup.leave()
                }
                return
            }

            let maskImage = UIImage(cgImage: self.maskedImage!)
            let baseImage = UIImage(cgImage: imageRef)
            let newImage = self.imageMerge(baseImage: baseImage, overImage: maskImage)
            CGImageDestinationAddImage(destination, newImage!, frameProperties as CFDictionary)
            if requestedTime == times.last?.timeValue {
                gifGroup.leave()
            }
        })
        
        // Wait for the asynchronous generator to finish.
        gifGroup.wait()
        
        CGImageDestinationSetProperties(destination, fileProperties as CFDictionary)
        
        CGImageDestinationFinalize(destination)
        
        return fileUrl
    }
}

