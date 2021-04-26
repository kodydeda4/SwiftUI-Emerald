//
//  NewWindowSettings.swift
//  Emerald
//
//  Created by Kody Deda on 3/9/21.
//

import SwiftUI
import ComposableArchitecture
import KeyboardShortcuts

struct PlacementSettingsView: View {
    let store: Store<Yabai.State, Yabai.Action>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            ScrollView {
                VStack(alignment: .leading) {
                    SectionView("Placement") {
                        // Placement
                        VStack(alignment: .leading) {
                            Text("Placement")
                                .bold().font(.title3)
                            
                            Picker("", selection: viewStore.binding(keyPath: \.windowPlacement, send: Yabai.Action.keyPath)) {
                                ForEach(Yabai.State.WindowPlacement.allCases) {
                                    Text($0.labelDescription.lowercased())
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 200)
                            
                            Text(viewStore.windowPlacement.caseDescription)
                                .foregroundColor(Color(.gray))
                        }
                        // Split Ratio
                        VStack(alignment: .leading) {
                            Divider()
                            
                            Text("Split Ratio")
                                .bold().font(.title3)
                            
                            Picker("", selection: viewStore.binding(keyPath: \.windowBalance, send: Yabai.Action.keyPath)) {
                                ForEach(Yabai.State.WindowBalance.allCases) {
                                    Text($0.labelDescription.lowercased())
                                }
                            }
                            .labelsHidden()
                            .pickerStyle(SegmentedPickerStyle())
                            .frame(width: 200)
                            
                            Slider(value: viewStore.binding(keyPath: \.splitRatio, send: Yabai.Action.keyPath))
                                .disabled(viewStore.windowBalance != .custom)
                                .opacity(viewStore.windowBalance != .custom ? 0.5 : 1.0)
                            
                            Text(viewStore.windowBalance.caseDescription)
                                .foregroundColor(Color(.gray))
                        }
                    }
                }
            }
            .frame(maxWidth: 1200)
            .padding()
        }
    }
}

// MARK:- SwiftUI_Previews
struct NewWindowSettings_Previews: PreviewProvider {
    static var previews: some View {
        PlacementSettingsView(store: Yabai.defaultStore)
    }
}
