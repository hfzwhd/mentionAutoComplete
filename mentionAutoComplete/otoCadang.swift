//
//  otoCadang.swift
//  mentionAutoComplete
//
//  Created by Hafiz Wahid on 11/05/2017.
//  Copyright © 2017 hw. All rights reserved.
//

import Foundation

class otoCadang {
    
    var foundRange: NSRange = NSRange()
    
    static let sharedInstance = otoCadang()
    
    init() {}
    
    func lookingForTag(_ string: String, position: NSRange) -> (tag: String, range: NSRange)? {
        if string.isEmpty {
            return nil
        }
        
        let nsString: NSString = string as NSString
        let start: Int = position.location
        let length: Int = nsString.length
        
        var wordStart: Int = start
        var wordEnd: Int = start
        
        if start > 0 {
            for i in stride(from: start, to: 0, by: -1) {
                let nsRange = NSMakeRange(i - 1, 1)
                let char = nsString.substring(with: nsRange)
                
                if char == " " || char == "\n" || char == "\t" {
                    break
                }
                
                wordStart = i - 1
            }
            
        }
        
        for i in start ..< length {
            let nsRange = NSMakeRange(i, 1)
            let char = nsString.substring(with: nsRange)
            
            if char == " " || char == "\n" || char == "\t" {
                break
            }
            
            wordEnd = i + 1
        }
        
        let nsRange = NSMakeRange(wordStart, wordEnd - wordStart)
        let char = nsString.substring(with: nsRange)
        
        
        if char.hasPrefix("@") || char.hasPrefix("$") {
            return (tag: char, range: nsRange)
        }
        
        return nil
    }
}
