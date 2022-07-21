//
//  String+Extension.swift
//  Stargazers
//
//  Created by Marco Iacobelli on 20/07/22.
//

import Foundation
extension String: LocalizedError {
    public var errorDescription: String? { return self }
}
