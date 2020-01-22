//
//  String+Extensions.swift
//  MapPoints
//
//  Created by Artem on 27.12.2019.
//  Copyright © 2019 Artem. All rights reserved.
//

import Foundation

fileprivate let lproj = "lproj" // localized file extension

// MARK: String extension
extension String {
    
    public var localizedString: String {
        return localized()
    }
    
    /// used to localize string from code
    public func localized(in language: String? = nil) -> String {
        guard let bundle = String.bundleForLanguage(language) else {
            return NSLocalizedString(self, comment: "")
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, comment: "")
    }
    
    public static var bundleForLanguage: (_ language: String?) -> Bundle? = { language in
        if let path = Bundle.main.path(forResource: language ?? Locale.current.languageCode, ofType: lproj),
            let bundle = Bundle(path: path) {
            return bundle
        }
        return nil
    }
    
}
