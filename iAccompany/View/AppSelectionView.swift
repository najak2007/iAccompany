//
//  AppSelectionView.swift
//  iAccompany
//
//  Created by najak on 5/9/26.
//

import SwiftUI
import FamilyControls
import ManagedSettings

struct AppSelectionView: View {
    @State var selection = FamilyActivitySelection()
    @State var isPickerPresented = false
    let store = ManagedSettingsStore()
    
    var body: some View {
        VStack {
            Button("앱 선택") {
                isPickerPresented = true
            }
            .familyActivityPicker(isPresented: $isPickerPresented, selection: $selection)
            
            Button("선택한 앱 차단") {
                store.shield.applications = selection.applicationTokens
            }
            
            Button("차단 해제") {
                store.shield.applications = nil
            }
        }
    }
}
