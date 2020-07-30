//
//  AppData.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 27/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import Foundation

final class AppData: ObservableObject {
    @Published var baseFileURLs: [URL]?
    @Published var currentLocalisedContent: LocalisedContent = generateSampleData()
    @Published var showOnlyUntranslated = false
    @Published var searchString: String = ""
//    @Published var filter: FilterType = FilterType(textValue: nil)
}
