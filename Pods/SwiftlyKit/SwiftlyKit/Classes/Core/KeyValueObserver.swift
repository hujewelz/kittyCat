//
//  KeyValueObserver.swift
//  SWKit
//
//  Created by huluobo on 2018/1/23.
//

import Foundation

public class KeyValueObserver<T>: NSObject {
    
    private let keyPath: String
    private let object: NSObject
    private let callback: (T) -> Void
    
    public init(object: NSObject, keyPath: String, callback: @escaping (T) -> Void) {
        self.object = object
        self.keyPath = keyPath
        self.callback = callback
        super.init()
        object.addObserver(self, forKeyPath: keyPath, options: [.new], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath, keyPath == self.keyPath,
            let object = object as? NSObject, object == self.object,
            let value = change?[.newKey] as? T else { return }
        
        callback(value)
    }
    
    deinit {
        object.removeObserver(self, forKeyPath: keyPath)
    }
}
