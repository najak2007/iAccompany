//
//  Schedule.swift
//  iAccompany
//
//  Created by 오션블루 on 5/15/26.
//

import Foundation
import DeviceActivity

extension DeviceActivityName {
    static let daily = Self("daily")
}

extension DeviceActivityEvent.Name {
    static let encouraged = Self("encouraged")
}

let schedule = DeviceActivitySchedule(
    intervalStart: DateComponents(hour: 17, minute: 45),
    intervalEnd: DateComponents(hour: 01, minute: 20),
    repeats: true
)

class Schedule {
    var center = DeviceActivityCenter()
    
    public func setSchedule() {
        
        print("스케쥴 셋팅 시작....")
        print("현재 시간 분: ", Calendar.current.dateComponents([.hour, .minute], from: Date()))
        
        do {
            print("스케쥴 모니터링 시작....")
            try center.startMonitoring(.daily, during: schedule)
        } catch {
            print("스케쥴 모니터링 실패:: ", error)
        }
    }
}
