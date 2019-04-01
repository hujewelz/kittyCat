//
//  UIImage+Extension.swift
//  DogSay
//
//  Created by jewelz on 2017/5/1.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import Foundation
import ImageIO
import AVFoundation

public extension UIImageView {
    
    func gif(named: String) {
        image = UIImage.animageGIF(named: named)
    }
}

public extension UIImage {
    
    /// Create image with gif data
    public static func animatedGIF(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            return nil
        }
        
        var animatedImage: UIImage?
        
        let count = CGImageSourceGetCount(source)
        if count <= 1 {
            animatedImage = UIImage(data: data)
        }
        else {
            var images = [UIImage]()
            
            var duration = 0.0
            
            for i in 0 ..< count {
                
                let image = CGImageSourceCreateImageAtIndex(source, i, nil)
                
                //duration = duration
                images.append(UIImage(cgImage: image!, scale: UIScreen.main.scale, orientation: .up))
            }
            
            duration = max((1 / 8) * Double(count), 1.5)
            
            animatedImage = UIImage.animatedImage(with: images, duration: duration)
            
        }
        
        return animatedImage
    }
    
    /// Create image with gif file name
    /// - Parameter named: name of the gif
    /// - Returns: The image created by gif fle name
    public static func animageGIF(named: String) -> UIImage? {
        
        guard let url = Bundle.main.url(forResource: named, withExtension: ".gif") else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        return animatedGIF(data: data)
    }
    
    
    public static func image(with color: UIColor) -> UIImage? {
    
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 2, height: 2), false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: 2, height: 2))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    public func data() -> Data? {
        var imageData: Data?
        
        if let data = UIImagePNGRepresentation(self) {
            if data.count > 1024 * 500 {
                imageData = UIImageJPEGRepresentation(self, 1)
                
                if imageData != nil && imageData!.count > 1024 * 500 {
                    let img = UIImage(data: imageData!, scale: UIScreen.main.scale)
                    imageData = UIImageJPEGRepresentation(img!, 0.1)
                }
                
            } else {
                imageData = data
            }
        } else {
            imageData = UIImageJPEGRepresentation(self, 1)
            if imageData != nil && imageData!.count > 1024 * 500 {
                let img = UIImage(data: imageData!, scale: scale)
                imageData = UIImageJPEGRepresentation(img!, 0.1)
            }
        }
        
        return imageData
    }
    
    public static func videoThumbnail(with url: URL) -> UIImage? {
        let asset = AVURLAsset(url: url)
        
        let gen = AVAssetImageGenerator(asset: asset)
        gen.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 5, preferredTimescale: 60)
        var actualTime = CMTime()
        guard let image = try? gen.copyCGImage(at: time, actualTime: &actualTime) else {
            return nil
        }
        
        let thumb = UIImage(cgImage: image)
        
        return thumb
    }
    
    public func circleImage() -> UIImage? {
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext()
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context?.addEllipse(in: rect)
        context?.clip()
        draw(in: rect)
        guard let cgImage = context?.makeImage() else {
            return nil
        }
        let image = UIImage(cgImage: cgImage)
        UIGraphicsEndImageContext()
        return image
    }
    /// 获取当前设备对应的启动图
    public static var launchImage: UIImage {
        let screenSize = UIScreen.main.bounds.size
        var launchImage: String?
        guard let imagesDic = Bundle.main.infoDictionary?["UILaunchImages"] as? Array<Dictionary<String, String>> else { return UIImage() }
        for dic in imagesDic {
            guard let sizeString = dic["UILaunchImageSize"], let orientation = dic["UILaunchImageOrientation"] else { break }
            let imageSize = CGSizeFromString(sizeString)
            if imageSize == screenSize && orientation == "Portrait" {
                launchImage = dic["UILaunchImageName"]
                break
            }
        }
        return UIImage(named: launchImage ?? "") ?? UIImage()
    }
    
    public var screenAspectFitHeight: CGFloat {
        return ScreenW * self.size.height / self.size.width
    }
    
}

internal extension UIImage {
    static func bundleImage(named imageName: String) -> UIImage? {
        let bundleImage = UIImage(named: imageName, in: Bundle(for: SwiftlyKit.self), compatibleWith: nil)
        let image = UIImage(named: imageName)
        return image != nil ? image! : bundleImage
    }
}
