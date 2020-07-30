//
//  LocalisationItemList.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 27/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import Foundation
import SwiftUI

struct LocalisationItemList: View {
    @EnvironmentObject private var appData: AppData
    @Binding var selectedLocalisedItem: LocalisedItem?
    @State var showUntranslatedOnly = false
    @State var searchString = ""

    var body: some View {
        List(selection: $selectedLocalisedItem) {
            Filter(searchString: $searchString, filtering: $showUntranslatedOnly)
            Spacer()
            ForEach(generateSampleData().all()!) { localisedItem in
                if (self.showUntranslatedOnly && !localisedItem.isFullyTranslated(allRequestedlocales: Array(generateSampleData().supportedLocales))) || !self.showUntranslatedOnly {
                    LocalisedItemRow(localisedItem: localisedItem, availableLocales: Array(generateSampleData().supportedLocales)).tag(localisedItem)
                }
            }
        }
    }
}

struct LocalisationItemList_Previews: PreviewProvider {
    static var previews: some View {
        LocalisationItemList(selectedLocalisedItem: .constant(generateSampleData().allTranslatedContent().first!))
            .environmentObject(AppData())
    }
}
