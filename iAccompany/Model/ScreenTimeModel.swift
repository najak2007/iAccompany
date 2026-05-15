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
    
    func saveSelection() {
        let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.co.kr.oceanbleu")
        let archiveURL = documentsDirectory?.appendingPathComponent("selection.plist")
        let encoder = PropertyListEncoder()
        
        if let dataToSave = try? encoder.encode(selectedtoLimit) {
            do {
                try dataToSave.write(to: archiveURL!)
                print("저장 성공")
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func getSelection() -> FamilyActivitySelection {
        let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.co.kr.oceanbleu")
        
        guard let archiveURL = documentsDirectory?.appendingPathComponent("selection.plist")
        else {
            print("가져오기 실패: selection.plist 없음")
            return FamilyActivitySelection()
        }
        
        guard let codeData = try? Data(contentsOf: archiveURL)
        else {
            print("가져오기 실패: codeData 없음")
            return FamilyActivitySelection()
        }
        
        print("가져오기 성공")
        let decoder = PropertyListDecoder()
        
        let loadedSelection = (try! decoder.decode(FamilyActivitySelection.self, from: codeData))
        print("loadedSelection: \(loadedSelection.applicationTokens)")
        
        return loadedSelection
    }
}
