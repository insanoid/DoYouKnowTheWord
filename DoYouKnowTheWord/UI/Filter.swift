//
//  Filter.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 28/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import Foundation

import SwiftUI

struct Filter: View {
    @EnvironmentObject private var appData: AppData
    @Binding var searchString: String
    @Binding var filtering: Bool

    var body: some View {
        HStack {
            TextField("Search", text: $searchString)
            Spacer()
            Toggle(isOn: $filtering) {
                Text("Issues")
            }
        }.padding(.all, 5)
    }
}

// struct Filter_Previews: PreviewProvider {
//    static var previews: some View {
//        @Binding var searchString: String = "value"
//        @Binding var filtering: Bool = false
//        return Filter(searchString: searchString, filtering: filtering)
//            .environmentObject(AppData())
//    }
// }

// enum FilterTranslated {
//    case All
//    case Untranslated
//    case Translated
// }
//
// struct FilterType: Hashable, Identifiable {
//    var textValue: String?
//    var isTranslated: FilterTranslated
//
//    init(textValue: String? = nil, isTranslated: FilterTranslated = .All) {
//        self.textValue = textValue
//        self.isTranslated = isTranslated
//    }
//
//    var id: FilterType {
//        return self
//    }
//
//    init(textValue _: String? = nil) {
//        textValue = nil
//        isTranslated = .All
//    }
//
//    static var all = FilterType()
// }
