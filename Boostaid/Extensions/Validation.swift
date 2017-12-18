//
//  Validation.swift
//  Boostaid
//
//  Created by Wondo Choung on 11/10/17.
//  Copyright © 2017 Wondo Choung. All rights reserved.
//

import Foundation

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count && self.characters.count == 10
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
