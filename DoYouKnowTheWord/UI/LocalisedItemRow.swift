//
//  LocalisedItemRow.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 27/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import SwiftUI

struct LocalisedItemRow: View {
    var localisedItem: LocalisedItem
    var availableLocales: [Locale]

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 3) {
                Text(localisedItem.id)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(minWidth: 20)
                if localisedItem.context != nil {
                    Text(localisedItem.context!)
                        .font(.caption)
                        .opacity(0.625)
                        .lineLimit(2)
                        .truncationMode(.middle)
                }
            }
            Spacer()
            if !localisedItem.isFullyTranslated(allRequestedlocales: availableLocales) {
                Text("🔴")
//                Image("star-filled")
//                    .resizable()
//                    .renderingMode(.template)
//                    .foregroundColor(.yellow)
//                    .frame(width: 10, height: 10)
            } else {
                Text("🟢")
//                Image("star-empty")
//                    .resizable()
//                    .renderingMode(.template)
//                    .foregroundColor(.yellow)
//                    .frame(width: 10, height: 10)
            }
        }.padding(.all, 5)
    }
}

struct LocalisedItemRow_Previews: PreviewProvider {
    static var previews: some View {
        let locale = Locale(identifier: "de_DE")
        var item = LocalisedItem("Key 1")
        item.context = "Sample Context"
        item.updateTranslation(locale: locale, translationValue: "English value")
        return LocalisedItemRow(localisedItem: item, availableLocales: [locale])
    }
}
