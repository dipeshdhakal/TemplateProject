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
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.launch()
        let viewExists = app.otherElements["OnboardingRootView"].waitForExistence(timeout: 5)
        XCTAssertTrue(viewExists)
    }
    
    @MainActor func testLogin() throws {
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.setOnboardingCompleted()
        app.launch()
        let viewExists = app.otherElements["LoginView"].waitForExistence(timeout: 5)
        XCTAssertTrue(viewExists)

    }
    
    @MainActor func testDashboard() throws {
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.setOnboardingCompleted()
        app.setLoginCompleted()
        app.launch()
        let viewExists = app.otherElements["HomeView"].waitForExistence(timeout: 5)
        XCTAssertTrue(viewExists)

    }
    
    // This does not test shit
    @MainActor func testPrivacyScreenOnBackground() throws {
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.launch()
        XCUIDevice.shared.press(.home)
        let background = app.wait(for: .runningBackground, timeout: 5)
        XCTAssertTrue(background)
        app.activate()
        let foreground = app.wait(for: .runningForeground, timeout: 5)
        XCTAssertTrue(foreground)
    }
    
    @MainActor func testBiometricScreenIfEnabled() throws {
        let app = XCUIApplication()
        app.launchArguments = launchArguments
        app.setOnboardingCompleted()
        app.setLoginCompleted()
        app.setBiometricEnabled()
        
        app.launch()
        
        let faceID = app.images.element(matching: .image, identifier: "faceid")
        let faceIDExists = faceID.waitForExistence(timeout: 5)
        
        XCTAssertTrue(faceIDExists)

    }

}
