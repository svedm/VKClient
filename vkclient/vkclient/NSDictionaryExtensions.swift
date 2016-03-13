//
//  NSDictionaryExtentions.swift
//  vkclient
//
//  Created by Svetoslav Karasev on 14.03.16.
//  Copyright © 2016 Svetoslav Karasev. All rights reserved.
//

import Foundation

extension NSDictionary {
    
    func parseField<T>(withName name: String, defaultValue: T) -> T {
        if let param = self.objectForKey(name) {
            return param as! T
        }
        
        return defaultValue
    }
}