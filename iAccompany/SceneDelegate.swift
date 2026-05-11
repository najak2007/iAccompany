//
//  SceneDelegate.swift
//  iAccompany
//
//  Created by 오션블루 on 5/11/26.
//

import SwiftUI
import FamilyControls
import ManagedSettings

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let screenTimeModel = ScreenTimeModel.shared
        let contentView = ContentView().environmentObject(screenTimeModel)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene


        window?.rootViewController = UIHostingController(rootView: contentView)
        window?.makeKeyAndVisible()
    }
}
