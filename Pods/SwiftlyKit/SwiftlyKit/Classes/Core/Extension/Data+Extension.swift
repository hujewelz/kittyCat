//
//  Data+Extension.swift
//  DogSay
//
//  Created by jewelz on 2017/5/11.
//  Copyright © 2017年 jewelz. All rights reserved.
//

import Foundation

public extension Data {
    
    public var fileExtension: String? {
        var c: [UInt8] = Array(repeating: 0, count: 2)
        
        copyBytes(to: &c, count: 2)
        
        switch c[0] {
        case 0xFF:
            if c[1] == 0xF9 {
                return ".mp3"
            } else {
                return ".jpeg"
            }
            
        case 0x89:
            return ".png"
        case 0x47:
            return ".gif"
        case 0x49: fallthrough
        case 0x4D:
            return ".tiff"
        case 0x41:
            return ".avi"
        case 0x00:
            return ".mp4"
        case 0x6D:
            return ".mov"
        default:
            return nil
        }
    }
        
}
