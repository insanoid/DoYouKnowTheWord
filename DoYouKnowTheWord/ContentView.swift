//
//  ContentView.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 15/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    // Row that is selected in the sidebar.
    @State private var selectedLocalisedItem: LocalisedItem?
    @EnvironmentObject var applicationState: ApplicationState
    
    var body: some View {
        NavigationView {
            NavigationPrimary(selectedLocalisedItem: $selectedLocalisedItem)
            if selectedLocalisedItem != nil {
                NavigationDetail(localisedItem: selectedLocalisedItem!)
            }
        }
        .frame(minWidth: 700, minHeight: 300)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ApplicationState.init(content: generateSampleData()))
    }
}
