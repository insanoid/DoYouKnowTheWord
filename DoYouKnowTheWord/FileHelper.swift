//
//  FileHelper.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 28/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import Foundation

func readJSONTranslationFiles(urls: [URL]) -> [String: [String: String]] {
    var parsedResponse: [String: [String: String]] = Dictionary()
    for url in urls {
        let jsonData = try! Data(contentsOf: url)
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String: String]
        parsedResponse.updateValue(json, forKey: url.fileNameWithoutExtension())
    }
    return parsedResponse
}

extension URL {
    func fileNameWithoutExtension() -> String {
        return deletingPathExtension().lastPathComponent
    }
}
