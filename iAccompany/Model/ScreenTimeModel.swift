//
//  ScreenTimeModel.swift
//  iAccompany
//
//  Created by najak on 5/10/26.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import Combine

class ScreenTimeModel: ObservableObject {
    static var shared = ScreenTimeModel()
    let store = ManagedSettingsStore()
    
    @Published var selectedtoLimit: FamilyActivitySelection
    
    init() {
        selectedtoLimit = FamilyActivitySelection()
    }
    
    func setShieldRestrictions() {
        let applications = ScreenTimeModel.shared.selectedtoLimit
        
        store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
        store.shield.applicationCategories = applications.categoryTokens.isEmpty
        ? nil
        : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
    }
}
