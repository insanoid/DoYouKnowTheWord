//
//  NavigationPrimary.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 28/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import Foundation
import SwiftUI

struct NavigationPrimary: View {
    @Binding var selectedLocalisedItem: LocalisedItem?

    var body: some View {
        VStack {
            LocalisationItemList(selectedLocalisedItem: $selectedLocalisedItem)
            .listStyle(SidebarListStyle())
        }
        .frame(minWidth: 280, maxWidth: 300)
    
    .padding(0)
    }
}

struct NavigationPrimary_Previews: PreviewProvider {
    static var previews: some View {
        NavigationPrimary(selectedLocalisedItem: .constant(generateSampleData().allTranslatedContent().first!))
            .environmentObject(ApplicationState.init(content: generateSampleData()))
    }
}
