//
//  IADeviceMonitor.swift
//  ActivityMonitor
//
//  Created by najak on 5/10/26.
//

import DeviceActivity
import ManagedSettings
import FamilyControls
import Foundation
import UserNotifications

class IADeviceMonitor: DeviceActivityMonitor {
    let sharedStorage = UserDefaults(suiteName: "iAccompanyStorage")
    let store = ManagedSettingsStore()
    
    
    func getSelection() -> FamilyActivitySelection {
        let documentsDirectory = FileManager().containerURL(forSecurityApplicationGroupIdentifier: "group.co.kr.oceanbleu")
        
        guard let archiveURL = documentsDirectory?.appendingPathComponent("selection.plist")
        else {
            print("FamilyActivitySelection 가져오기 실패: selection.plist 없음")
            return FamilyActivitySelection()
        }
        
        guard let codeData = try? Data(contentsOf: archiveURL)
        else {
            print("FamilyActivitySelection 가져오기 실패: codeData 없음")
            return FamilyActivitySelection()
        }
        
        print("FamilyActivitySelection 가져오기 성공")
        
        let decoder = PropertyListDecoder()
        let loadedSelection = (try! decoder.decode(FamilyActivitySelection.self, from: codeData))
        print("loadedSelection: \(loadedSelection.applicationTokens)")
        
        return loadedSelection
    }
    
    func showLocalNotification(title: String, desc: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = desc
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "localNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("로컬 푸시 실패: \(error.localizedDescription)")
            } else {
                print("로컬 푸시 성공")
            }
        }
    }
    
    // 장치 활동 간격이 시작
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)

        let selection = getSelection()
        
        let applications = selection
            store.shield.applications = applications.applicationTokens.isEmpty ? nil : applications.applicationTokens
            store.shield.applicationCategories = applications.categoryTokens.isEmpty
            ? nil
            : ShieldSettings.ActivityCategoryPolicy.specific(applications.categoryTokens)
        showLocalNotification(title: "intervalDidStart", desc: "\(applications.applicationTokens)")
    }
    
    // 장치 활동 간격이 끝
    override func intervalDidEnd(for activity: DeviceActivityName) {
        super.intervalDidEnd(for: activity)
    }
    
    // 활동이 지정한 임계값에 도달하면 호출됨
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
    }
    
    // 활동 시작전에 startMonitoring의 warningTime분 전에 알림 (시작 n분적, 종료 n분전)
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
    }
    
    // 활동이 지정한 임계값에 도달할 예정일때 호출됨
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
    }
 
    
    private func blockSelectedApps(_ selection: FamilyActivitySelection) {
        // 앱 차단 설정
        store.shield.applications = selection.applicationTokens.isEmpty ?
            nil : selection.applicationTokens
        
        // 카테고리 차단 설정
        store.shield.applicationCategories = selection.categoryTokens.isEmpty
        ? nil
        : .specific(selection.categoryTokens)
        
        // 웹 도메인 차단 설정 (필요한 경우)
        store.shield.webDomains = selection.webDomainTokens.isEmpty
        ? nil
        : selection.webDomainTokens
    }
    
    func unblockApps() {
        store.shield.applications = nil
        store.shield.applicationCategories = nil
        store.shield.webDomains = nil
    }
}
