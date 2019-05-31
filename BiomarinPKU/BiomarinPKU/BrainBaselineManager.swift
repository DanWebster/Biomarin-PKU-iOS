//
//  BrainBaselineManager.swift
//  BiomarinPKU
//
//  Copyright © 2017 Sage Bionetworks. All rights reserved.
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

import BridgeApp
import BrainBaseline

/**
 BrainBaseline results are uploaded to their servers for processing, and the processed values
 will be exported from there directly into Synapse. All that will be uploaded to Bridge from
 here will be the usual metadata. The results returned for the dashboard need to reference the
 user context.
 */

class BrainBaselineManager: NSObject {
    
    #if DEBUG
    static let studyId = "biomarin-pku-dev"
    #else
    static let studyId = "biomarin-pku"
    #endif
    
    static let studyBundle: Bundle = {
        let studyBundlePath = Bundle.main.path(forResource: "BBLStudy-BioMarin-PKU", ofType: "bundle")!
        return Bundle(path: studyBundlePath)!
    }()

    static let brainBaselineContext: BBLContext = {
        return BBLContext(studyId: studyId, resourceBundle: studyBundle, serverInfo: BBLServerInfo.default())
    }()
    
    static let tasks = [
        RSDIdentifier.spatialMemoryTask.rawValue: "PTSPWM-Phone-BioMarin-PKU",
        RSDIdentifier.attentionalBlinkTask.rawValue: "PTBlink-Phone-BioMarin-PKU",
        RSDIdentifier.symbolSubstitutionTask.rawValue: "PTVerbalSymbolSwap-Phone-BioMarin-PKU",
        RSDIdentifier.nBackTask.rawValue: "PTNBack-Phone-BioMarin-PKU",
        RSDIdentifier.goNoGoTask.rawValue: "PTFaceTask-Phone-BioMarin-PKU",
        RSDIdentifier.taskSwitchTask.rawValue: "TODO get it from brain baseline team"
    ]

//    class func getUser() -> BBLUser {
//        // Get the current user
//        let bridgeUser = (UIApplication.shared.delegate as! SBAAppDelegate).currentUser
//        let userName = bridgeUser.uniqueIdentifier()
//        var user = BBLUser.existingUser(withName: userName, in: self.brainBaselineContext)
//        if (user == nil) {
//            user = BBLUser.newUser(withName: userName, in: self.brainBaselineContext)
//            let properties = brainBaselineProperties(with: bridgeUser)
//            for (key, value) in properties {
//                user!.setProperty(key, value: value)
//            }
//        } else {
//            let properties = brainBaselineProperties(with: bridgeUser)
//            for (key, value) in properties {
//                user!.setProperty(key, value: value)
//            }
//        }
//        return user!
//    }
    
//    class func brainBaselineProperties(with bridgeUser: SBAUserWrapper) -> [String: Any] {
//        var bblProps = [String: Any]()
//
//        let dataGroups = bridgeUser.dataGroups ?? []
//        bblProps["study_group"] = dataGroups.contains("test_user") ? "test_user" :
//            dataGroups.contains("ms_patient") ? "ms" :
//        "control"
//
//        // if user has consented we will have their birthdate (at least the year).
////        let year = Calendar.current.component(.year, from: bridgeUser.birthdate!)
////        bblProps["birth_year"] = year.description
////
////        let gender = SBAProfileManager.shared?.value(forProfileKey: SBAProfileInfoOption.gender.rawValue)
////        let genderString: String? = (gender as? String) ?? ((gender as? HKBiologicalSex)?.demographicDataValue as String?)
////        if genderString != nil {
////            bblProps["gender"] = genderString
////        }
////
////        var bbl_education: String? = nil
////        if let education = SBAProfileManager.shared?.value(forProfileKey: "education") as? String {
////            switch education {
////            case "Some_high_school":
////                bbl_education = "Some High School"
////            case "High_school_diploma_GED":
////                bbl_education = "High School"
////            case "Some_college":
////                bbl_education = "Some College"
////            case "College_degree":
////                bbl_education = "Bachelor's Degree"
////            case "Post-graduate_Degree":
////                bbl_education = "Graduate Degree"
////            case "Other":
////                bbl_education = "Other"
////            default:
////                assertionFailure("Unrecognized education value: \(education)")
////                break
////            }
////        }
////        if bbl_education != nil {
////            bblProps["education"] = bbl_education
////        }
//
//        return bblProps
//    }
//}
//
//class BrainBaselineStepViewController: SBABrainBaselineStepViewController, BBLPsychTestViewControllerDelegate {
//
//    override var result: ORKStepResult? {
//        guard let stepResult = super.result else { return nil }
//
//        let userIdResult = ORKTextQuestionResult(identifier: "userIdentifier")
//        let bridgeUser = (UIApplication.shared.delegate as! SBAAppDelegate).currentUser
//        userIdResult.textAnswer = bridgeUser.uniqueIdentifier()
//        stepResult.addResult(userIdResult)
//
//        return stepResult
//    }
//
//    override func createTestViewController() -> UIViewController? {
//        do {
//            let user = BrainBaselineManager.getUser()
//            let controller = try BBLPsychTestViewController(psychTestNamed: self.testName!, in: BrainBaselineManager.brainBaselineContext)
//            controller.user = user
//            controller.sessionId = self.taskViewController!.taskRunUUID.uuidString
//            controller.delegate = self
//            return controller
//        }
//        catch let error {
//            print("Error creating the BBLPsychTestViewController: \(error)")
//        }
//        return nil
//    }
//
//    func psychTestViewControllerDidFinish(_ controller: BBLPsychTestViewController) {
//
//        if let resultIdUnwrapped = controller.psychTestResultID {
//            do {
//                let result = try BBLPsychTestResult(id: resultIdUnwrapped, in: BrainBaselineManager.brainBaselineContext)
//                BrainBaselineManager.updateScores(forResult: result, isExistingResultId: false)
//            }
//            catch let error {
//                assertionFailure("error getting BBLPsychTestResult for id \(resultIdUnwrapped): \(error)")
//            }
//        }
//
//        self.testDidFinish(result: controller.psychTestResultID)
//    }
//
//}
}
