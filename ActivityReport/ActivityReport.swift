//
//  ActivityReport.swift
//  ActivityReport
//
//  Created by najak on 5/10/26.
//

import DeviceActivity
import ExtensionKit
import SwiftUI

@main
struct ActivityReport: DeviceActivityReportExtension {
    var body: some DeviceActivityReportScene {
        // Create a report for each DeviceActivityReport.Context that your app supports.
        TotalActivityReport { totalActivity in
            TotalActivityView(totalActivity: totalActivity)
        }
        // Add more reports here...
    }
}
