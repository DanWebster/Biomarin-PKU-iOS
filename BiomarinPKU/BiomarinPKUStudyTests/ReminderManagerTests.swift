//
// ReminderManagerTests.swift
// BiomarinPKUStudyTests

// Copyright © 2019 Sage Bionetworks. All rights reserved.
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

import Foundation
import XCTest
import BridgeApp
@testable import BiomarinPKU_Study

class ReminderManagerTests: XCTestCase {
    
    open var manager: MockReminderManager {
        return ReminderManager.shared as! MockReminderManager
    }
    
    override func setUp() {
        super.setUp()
        ReminderManager.shared = MockReminderManager()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReminderStepTitle() {
        for dayIdx in 1...8 {
            XCTAssertEqual(ReminderType.daily.stepTitle(dayOfStudy: dayIdx), "When would you like to do the Daily Check-In?")
        }
        for dayIdx in 1...8 {
            XCTAssertEqual(ReminderType.sleep.stepTitle(dayOfStudy: dayIdx), "When would you like to do the Sleep Check-In?")
        }
        for dayIdx in 1...7 {
            XCTAssertEqual(ReminderType.physical.stepTitle(dayOfStudy: dayIdx), "Let’s set a Daily Reminder for your Physical Activity Challenge")
        }
        for dayIdx in 8...16 {
            XCTAssertEqual(ReminderType.physical.stepTitle(dayOfStudy: dayIdx), "Let’s set a Weekly Reminder for your Physical Activity Challenge")
        }
        for dayIdx in 1...7 {
            XCTAssertEqual(ReminderType.cognition.stepTitle(dayOfStudy: dayIdx), "Let’s set a Daily Reminder for your Cognitive Activity Challenge")
        }
        for dayIdx in 8...16 {
            XCTAssertEqual(ReminderType.cognition.stepTitle(dayOfStudy: dayIdx), "Let’s set a Weekly Reminder for your Cognitive Activity Challenge")
        }
    }
    
    func testDailyDateComponents() {
        var components = manager.dailyDateComponents(with: "12:34 AM")
        XCTAssertNil(components?.weekday)
        XCTAssertEqual(components?.hour, 0)
        XCTAssertEqual(components?.minute, 34)
        
        components = manager.dailyDateComponents(with: "12:34 PM")
        XCTAssertNil(components?.weekday)
        XCTAssertEqual(components?.hour, 12)
        XCTAssertEqual(components?.minute, 34)
    }
    
    func testWeekDateComponents() {
        var components = manager.weeklyDateComponents(with: "12:34 AM", on: .monday)
        XCTAssertEqual(components?.weekday, 2)
        XCTAssertEqual(components?.hour, 0)
        XCTAssertEqual(components?.minute, 34)
        
        components = manager.weeklyDateComponents(with: "9:02 PM", on: .saturday)
        XCTAssertEqual(components?.weekday, 7)
        XCTAssertEqual(components?.hour, 21)
        XCTAssertEqual(components?.minute, 2)
    }
}
