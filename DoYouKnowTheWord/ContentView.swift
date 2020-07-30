//
//  ContentView.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 15/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedLocalisedItem: LocalisedItem?

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
            .environmentObject(AppData())
    }
}

// struct ContentView: View {
//    var body: some View {
//        VStack(spacing: 16) {
//            InputView()
//            Spacer()
//        }
//        .padding(.top, 32)
//        .padding(.bottom, 16)
//        .frame(minWidth: 768, idealWidth: 768, maxWidth: 1024, minHeight: 648, maxHeight: 648)
//    }
// }
//
// struct InputView: View {
//    // @Binding var fileURLs: [URL]?
//
//    var body: some View {
//        VStack(spacing: 16) {
//            HStack {
//                Text("Select JSON Files").font(.caption)
//                Button(action: selectFiles) {
//                    Text("Select Files")
//                }
//            }
//            // InputFileView(image: nil)
//            Button(action: saveToFiles) { Text("Generate Files") }
//        }
//    }
//
//    private func selectFiles() {
//        NSOpenPanel.openJSONFiles { result in
//            if case let .success(jsonFileURLs) = result {
//                print(jsonFileURLs)
//            }
//        }
//    }
//
//    private func saveToFiles() {}
// }
