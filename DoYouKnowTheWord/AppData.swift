//
//  AppData.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 27/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import Foundation

// A class to use an environmental object and save the current state of content in.
final class ApplicationState: ObservableObject {
    @Published var localisedContent: LocalisedContent
    @Published var filter: FilterType = .All
    @Published var filterString: String
    
    init(content: LocalisedContent) {
        self.localisedContent = content
        self.filterString = ""
    }
    
    func allLocales() -> [Locale] {
        return Array(localisedContent.supportedLocales)
    }
}

