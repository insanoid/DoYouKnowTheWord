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
    @EnvironmentObject private var applicationState: ApplicationState
    @Binding var selectedLocalisedItem: LocalisedItem?

    var body: some View {
        VStack {
        Filter()
        List(selection: $selectedLocalisedItem) {
            ForEach(generateSampleData().all(applicationState.filterString, filterType: applicationState.filter)!) { localisedItem in
                LocalisedItemRow.init(localisedItem: localisedItem, availableLocales: Array.init(self.applicationState.localisedContent.supportedLocales))
            }
        }.padding(EdgeInsets.init(top: 10, leading: 0, bottom: 0, trailing: 0))
        .listStyle(SidebarListStyle())
        }
    }
}

struct LocalisationItemList_Previews: PreviewProvider {
    static var previews: some View {
        LocalisationItemList(selectedLocalisedItem: .constant(generateSampleData().allTranslatedContent().first!))
            .environmentObject(ApplicationState.init(content: generateSampleData()))
    }
}
