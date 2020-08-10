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
    @EnvironmentObject private var applicationState: ApplicationState
    @State var filtering: FilterType = .All

    var body: some View {
        VStack {
            TextField("Search", text: $applicationState.filterString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Picker(String(), selection: $applicationState.filter, content: {
                ForEach(0 ..< FilterType.allCases.count) {
                    Text(FilterType.allCases[$0].rawValue).tag(FilterType.allCases[$0])
                }
            }).pickerStyle(SegmentedPickerStyle())
        }.padding(.all, 5)
        
    }
}

 struct Filter_Previews: PreviewProvider {
    static var previews: some View {
        return Filter()
            .environmentObject(ApplicationState.init(content: generateSampleData()))
    }
 }
