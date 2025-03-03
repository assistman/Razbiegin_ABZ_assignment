//
//  RadioButtonsView.swift
//  Razbiegin_ABZ_assignment
//
//  Created by Stanislav Razbiegin on 03.03.2025.
//

import Foundation
import SwiftUI

struct RadioButtons: View {
    @Binding var selected: Int?
    @Binding var positions: [Position]

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(positions,id: \.id) {position in
                Button(action: {
                    self.selected = position.id
                }) {
                    HStack {
                        ZStack {
                            if self.selected == position.id {
                                Circle()
                                    .stroke(Color("radio_button_selected"), lineWidth: 5)
                                    .frame(width: 14, height: 14)
                            } else {
                                Circle()
                                    .stroke(Color.gray, lineWidth: 1)
                                    .frame(width: 14, height: 14)
                            }
                        }
                        Text(position.name)
                            .padding(.horizontal)
                    }.foregroundColor(.black)
                }.padding(.top, 8)
            }
        }
    }
}
