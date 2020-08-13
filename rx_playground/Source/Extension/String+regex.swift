//
//  String+regex.swift
//  rx_playground
//
//  Created by JSilver on 2020/08/13.
//

import Foundation

extension String {
    func regex(pattern: String) -> NSRange? {
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = regex?.matches(in: self, range: NSRange(location: 0, length: self.count))
        
        return range?.first?.range
    }
}
