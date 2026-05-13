//
//  DeviceActivityMonitorExtension.swift
//  ActivityMonitor
//
//  Created by najak on 5/10/26.
//

import DeviceActivity
import ManagedSettings
import FamilyControls
import Foundation

class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    let store = ManagedSettingsStore()
    
    // 장치 활동 간격이 시작
    override func intervalDidStart(for activity: DeviceActivityName) {
        super.intervalDidStart(for: activity)
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
