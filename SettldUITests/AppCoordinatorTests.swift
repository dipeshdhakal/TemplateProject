//
//  AppCoordinatorTests.swift
//  SettldUITests
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import XCTest

final class AppCoordinatorTests: BaseTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor func testOnboarding() throws {
        UserDefaults.standard.set(true, forKey: "UserOnboarded")
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.launch()
        
    }
    
    @MainActor func testLogin() throws {
        UserDefaults.standard.set(true, forKey: "UserOnboarded")
        UserDefaults.standard.set(false, forKey: "UserLoggedIn")
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.launch()

    }
    
    @MainActor func testDashboard() throws {
        UserDefaults.standard.set(true, forKey: "UserOnboarded")
        UserDefaults.standard.set(true, forKey: "UserLoggedIn")
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.launch()

    }
    
    @MainActor func testPrivacyScreenOnBackground() throws {
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.launch()

    }
    
    @MainActor func testBiometricScreenIfEnabled() throws {
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.launch()

    }

}
