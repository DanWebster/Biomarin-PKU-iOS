//
// BrainBaselineStepViewController.swift
// BiomarinPKUTests

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
@testable import BridgeApp
@testable import BiomarinPKU

class BrainBaselineStepViewControllerTests: XCTestCase {
    
    override func setUp() {
        // Put teardown code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testOrientationIncludes() {
        XCTAssertTrue(UIInterfaceOrientationMask.landscape.includes(orientation: .landscapeLeft))
        XCTAssertTrue(UIInterfaceOrientationMask.landscape.includes(orientation: .landscapeRight))
        XCTAssertFalse(UIInterfaceOrientationMask.landscape.includes(orientation: .portrait))
        
        XCTAssertFalse(UIInterfaceOrientationMask.portrait.includes(orientation: .landscapeLeft))
        XCTAssertFalse(UIInterfaceOrientationMask.portrait.includes(orientation: .landscapeRight))
        XCTAssertTrue(UIInterfaceOrientationMask.portrait.includes(orientation: .portrait))
    }
    
    func testOrientationForced() {
        XCTAssertEqual(UIInterfaceOrientationMask.landscape.forcedOrientation(for: .portrait), .landscapeRight)
        XCTAssertEqual(UIInterfaceOrientationMask.landscape.forcedOrientation(for: .portraitUpsideDown), .landscapeLeft)        
    }
    
    func testNibAndBundle() {
        XCTAssertEqual(BrainBaselineStepViewController.nibName, "BrainBaselineStepViewController")
        XCTAssertEqual(BrainBaselineStepViewController.bundle, Bundle(for: BrainBaselineStepViewController.classForCoder()))
    }
    
    func testStepObject() {
        XCTAssertNotNil(BrainBaselineStepObject.examples())
        XCTAssertTrue(BrainBaselineStepObject.examples().count > 0)
        
        let step = BrainBaselineStepObject(identifier: "foo", testName: "test")
        do {
            try step.validate()  // make sure it doesnt throw an error
        } catch let error {
            XCTAssertNotNil(error, "\(error)")
        }
        
        let vc = step.instantiateViewController(with: nil)
        XCTAssertNotNil(vc as? BrainBaselineStepViewController)
        let result = step.instantiateStepResult()
        XCTAssertNotNil(result)
        
        let answer = result as? RSDAnswerResultObject
        XCTAssertNotNil(answer)
        
        if let answerUnwrapped = answer {
            XCTAssertEqual(answerUnwrapped.identifier, "userIdentifier")
            XCTAssertEqual(answerUnwrapped.answerType, .string)
            
            let stringValue = answerUnwrapped.value as? String
            XCTAssertNotNil(answer)
            if let valueUnwrapped = stringValue {
                XCTAssertEqual(valueUnwrapped, BrainBaselineManager.bbIdentifier())
            }
        }
    }
}
