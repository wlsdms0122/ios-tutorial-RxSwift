//
//  String+split.swift
//  rx_playground
//
//  Created by JSilver on 2020/08/15.
//

import Foundation

extension String {
    func split(length: Int) -> [String] {
        var index = 0
        
        var result: [String] = []
        while index < self.count {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let endIndex = self.index(startIndex, offsetBy: length, limitedBy: self.endIndex) ?? self.endIndex
            
            result.append(String(self[startIndex ..< endIndex]))
            index += length
        }
        
        return result
    }
}
