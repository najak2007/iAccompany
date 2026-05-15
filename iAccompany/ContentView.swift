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

    @EnvironmentObject var screenTimeModel: ScreenTimeModel

    let center = AuthorizationCenter.shared
    
    var body: some View {
        VStack(spacing: 30) {
            Button("앱 차단 선택") {
                Task {
                    do {
                        try await center.requestAuthorization(for: .individual)
                        isPickerPresented = true
                    } catch {
                        print("권한 요청 실패 : \(error.localizedDescription)")
                    }
                }
            }
            .familyActivityPicker(isPresented: $isPickerPresented, selection: $screenTimeModel.selectedtoLimit)
            .onChange(of: screenTimeModel.selectedtoLimit) { oldSelection, newSelection in
                print("선택된 앱 차단 목록: \(newSelection)")
                ScreenTimeModel.shared.setShieldRestrictions()
                let _ = ScreenTimeModel.shared.getSelection()
            }
            
            Button("앱 모니터") {
                
            }
        }
        .padding()
    }
}
