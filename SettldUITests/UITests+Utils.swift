//
//  UITests+Utils.swift
//  Settld
//
//  Created by Dipesh Dhakal on 6/3/2025.
//

import XCTest

class BaseTestCase: XCTestCase {

    var launchArguments = ["IS_UI_TEST"]
}


extension XCUIElement {
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear value. Possibly non-string.")
            return
        }
        self.doubleTap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
        self.typeText(text)
    }
    
    
}

extension XCUIElement {

    var isOn: Bool? {
        return (self.value as? String).map { $0 == "1" }
    }
}

/*Sends a tap event to a hittable/unhittable element.*/
extension XCUIElement {
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVectorMake(0.0, 0.0))
            coordinate.tap()
        }
    }
}
