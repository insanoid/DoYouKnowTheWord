//
//  Data.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 28/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import Foundation

func generateSampleData() -> LocalisedContent {
    let DE_DElocale = Locale(identifier: "de_DE")
    let EN_GBlocale = Locale(identifier: "en_GB")
    let engbContent = ["Key 1": "EN_GB_VALUE1", "Key 2": "EN_GB_VALUE2", "Key 3": "EN_GB_VALUE3"]
    let dedeContent = ["Key 1": "DE_VALUE1", "Key 2": "DE_VALUE2"]
    let context = ["Key 1": "Context #1", "Key 2": "Context #2", "Key 3": "Context #3"]

    var localisedContent = LocalisedContent()
    localisedContent.addContext(content: context)
    localisedContent.addLocalisedContent(locale: DE_DElocale, content: dedeContent)
    localisedContent.addLocalisedContent(locale: EN_GBlocale, content: engbContent)
    return localisedContent
}
