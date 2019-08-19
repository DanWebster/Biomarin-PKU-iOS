//
//  PKUCopyStepTests.swift
//  BiomarinPKUTests
//
//  Copyright © 2019 Sage Bionetworks. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1.  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2.  Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//
// 3.  Neither the name of the copyright holder(s) nor the names of any contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission. No license is granted to the trademarks of
// the copyright holders even if such marks are included in this software.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

import XCTest
@testable import Research
@testable import BiomarinPKU_Study

class PKUCopyStepTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: `copy(with:)`
    
    func testCopy_BraineBaselineOverviewStepObject() {
        let step = BrainBaselineOverviewStepObject(identifier: "foo", nextStepIdentifier: "bar", type: "boo")
        step.title = "title"
        step.text = "text"
        
        step.viewTheme = RSDViewThemeElementObject(viewIdentifier: "fooView")
        step.colorMapping = RSDSingleColorThemeElementObject(colorStyle: .primary)
        step.imageTheme = RSDFetchableImageThemeElementObject(imageName: "fooIcon")
        
        step.measurements = "measurements"
        step.yourObjective = "objective"
        step.instructions = "instructions"
        
        step.actions = [.navigation(.learnMore) : RSDVideoViewUIActionObject(url: "fooFile", buttonTitle: "tap foo")]
        
        let copy = step.copy(with: "bar")
        XCTAssertEqual(copy.identifier, "bar")
        XCTAssertEqual(copy.stepType, "boo")
        XCTAssertEqual(copy.title, "title")
        XCTAssertEqual(copy.text, "text")
        XCTAssertEqual(copy.viewTheme?.viewIdentifier, "fooView")

        XCTAssertEqual((copy.colorMapping as? RSDSingleColorThemeElementObject)?.colorStyle, .primary)
        
        XCTAssertEqual((copy.imageTheme as? RSDFetchableImageThemeElementObject)?.imageName, "fooIcon")
        
        XCTAssertEqual(copy.measurements, "measurements")
        XCTAssertEqual(copy.yourObjective, "objective")
        XCTAssertEqual(copy.instructions, "instructions")
        
        XCTAssertEqual(copy.nextStepIdentifier, "bar")
        
        if let learnAction = copy.actions?[.navigation(.learnMore)] as? RSDVideoViewUIActionObject {
            XCTAssertEqual(learnAction.url, "fooFile")
            XCTAssertEqual(learnAction.buttonTitle, "tap foo")
        } else {
            XCTFail("\(String(describing: copy.actions)) does not include expected learn more action")
        }
    }
    
    func testCopy_ReminderStepObject() {
        let step = ReminderStepObject(identifier: "foo")
        step.title = "title"
        step.text = "text"
        
        step.viewTheme = RSDViewThemeElementObject(viewIdentifier: "fooView")
        step.colorMapping = RSDSingleColorThemeElementObject(colorStyle: .primary)
        step.imageTheme = RSDFetchableImageThemeElementObject(imageName: "fooIcon")
        
        step.alwaysShow = true
        step.defaultDayOfWeek = "Saturday"
        step.defaultTime = "9:00 AM"
        step.doNotRemindMeTitle = "title 2"
        step.hideDayOfWeek = true
        step.reminderType = .cognition
        
        step.actions = [.navigation(.learnMore) : RSDVideoViewUIActionObject(url: "fooFile", buttonTitle: "tap foo")]
        
        let copy = step.copy(with: "bar")
        XCTAssertEqual(copy.identifier, "bar")
        XCTAssertEqual(copy.title, "title")
        XCTAssertEqual(copy.text, "text")
        XCTAssertEqual(copy.viewTheme?.viewIdentifier, "fooView")
        
        XCTAssertEqual((copy.colorMapping as? RSDSingleColorThemeElementObject)?.colorStyle, .primary)
        
        XCTAssertEqual((copy.imageTheme as? RSDFetchableImageThemeElementObject)?.imageName, "fooIcon")

        XCTAssertEqual(copy.alwaysShow, true)
        XCTAssertEqual(copy.defaultDayOfWeek, "Saturday")
        XCTAssertEqual(copy.defaultTime, "9:00 AM")
        XCTAssertEqual(copy.doNotRemindMeTitle, "title 2")
        XCTAssertEqual(copy.hideDayOfWeek, true)
        XCTAssertEqual(copy.reminderType, .cognition)
        
        if let learnAction = copy.actions?[.navigation(.learnMore)] as? RSDVideoViewUIActionObject {
            XCTAssertEqual(learnAction.url, "fooFile")
            XCTAssertEqual(learnAction.buttonTitle, "tap foo")
        } else {
            XCTFail("\(String(describing: copy.actions)) does not include expected learn more action")
        }
    }
}
