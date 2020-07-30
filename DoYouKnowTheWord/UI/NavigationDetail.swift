//
//  NavigationDetails.swift
//  DoYouKnowTheWord
//
//  Created by Karthikeya Udupa on 28/07/2020.
//  Copyright © 2020 Karthikeya Udupa. All rights reserved.
//

import MapKit
import SwiftUI

struct NavigationDetail: View {
    @EnvironmentObject var appData: AppData
    var localisedItem: LocalisedItem
    @State var tableNumber = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack(alignment: .center, spacing: 3) {
                Text(localisedItem.id).font(.title)
                if localisedItem.isFullyTranslated(allRequestedlocales: Array(generateSampleData().supportedLocales)) {
                    Image("star-filled")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.yellow)
                        .accessibility(label: Text("Remove from favorites")).frame(width: 20, height: 20)
                } else {
                    Image("star-empty")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.gray)
                        .accessibility(label: Text("Add to favorites")).frame(width: 20, height: 20)
                }
                Spacer()
            }
            Text(localisedItem.context ?? "No Context").font(.subheadline)
            Divider().padding(5)
            Section(header: Text("EN_GB").font(.callout)) {
                TextField("EN_GB", text: $tableNumber)
                    .multilineTextAlignment(.leading)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }.padding(5)
//            HStack(alignment: .center, spacing: 3) {
//                Text(locale.identifier).font(.callout)
//                TextField(txt: localisedItem.translation(locale: locale))
//            }
//
//            ForEach(Array(generateSampleData().supportedLocales)) { locale in
//                HStack(alignment: .center, spacing: 3) {
//                    Text(locale.identifier).font(.callout)
//                    TextField(txt: localisedItem.translation(locale: locale))
//                }
//            }
//
//            ForEach(Array.init(generateSampleData().supportedLocales)) {locale in
//                 HStack(alignment: .center, spacing: 3) {
//                    Text(locale.identifier).font(.callout)
//
//                }
//            }
        }
        .padding()
        .frame(maxWidth: 700)
    }

//        VStack(alignment: .leading, spacing: 12) {
//                    HStack {
//                        Text(localisedItem,).font(.title)
//
//                        Button(action: {
//                            self.userData.landmarks[self.landmarkIndex]
//                                .isFavorite.toggle()
//                        }) {
//                            if userData.landmarks[self.landmarkIndex].isFavorite {
//                                Image("star-filled")
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .foregroundColor(.yellow)
//                                    .accessibility(label: Text("Remove from favorites"))
//                            } else {
//                                Image("star-empty")
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .foregroundColor(.gray)
//                                    .accessibility(label: Text("Add to favorites"))
//                            }
//                        }
//                        .frame(width: 20, height: 20)
//                        .buttonStyle(PlainButtonStyle())
//                    }
//
//                    Text(landmark.park)
//                    Text(landmark.state)
//                }
//                .font(.caption)
//            }
//
//            Divider()
//
//            Text("About \(landmark.name)")
//                .font(.headline)
//
//            Text(landmark.description)
//                .lineLimit(nil)
//
//        }
//        .padding()
//        .frame(maxWidth: 700)
//        .offset(x: 0, y: -50)
//    }
}

struct NavigationDetail_Previews: PreviewProvider {
    static var previews: some View {
        return NavigationDetail(localisedItem: generateSampleData().all()!.first!)
            .environmentObject(AppData())
    }
}
