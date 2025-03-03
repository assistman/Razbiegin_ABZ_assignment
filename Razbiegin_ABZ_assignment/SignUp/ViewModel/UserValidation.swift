//
//  UserValidation.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 03.03.2025.
//

import Foundation

extension String {

    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format:"SELF MATCHES %@", emailRegEx).evaluate(with: self)
    }

    var isValidPhone: Bool {
        return self.starts(with: "+380") && self.count == 13
    }
}
