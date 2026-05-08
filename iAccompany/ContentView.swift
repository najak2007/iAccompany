//
//  ContentView.swift
//  iAccompany
//
//  Created by 오션블루 on 5/7/26.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct ContentView: View {

    @State private var isPickerPresented = false
    @State private var selection = FamilyActivitySelection()

    var body: some View {
        VStack {
            Button("앱 차단 선택") {
                isPickerPresented.toggle()
            }
            .familyActivityPicker(isPresented: $isPickerPresented, selection: $selection)
            .onChange(of: selection) { oldSelection, newSelection in
                print("선택된 앱 차단 목록: \(newSelection)")
                blockApps(selection: newSelection)
            }
        }
        .padding()
    }
    
    func blockApps(selection: FamilyActivitySelection) {
        let store = ManagedSettingsStore()
        store.shield.applications = selection.applicationTokens
        store.shield.webDomains = selection.webDomainTokens
    }
    
    func unblockApps() {
        let store = ManagedSettingsStore()
        store.clearAllSettings()
    }
}
