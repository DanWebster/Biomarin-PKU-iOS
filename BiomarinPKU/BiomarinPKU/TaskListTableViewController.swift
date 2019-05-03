//
//  TaskListTableViewController.swift
//  BiomarinPKU
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

import UIKit
import BridgeApp
import BridgeSDK
import MotorControl

class TaskListTableViewController: UITableViewController, RSDTaskViewControllerDelegate {

    let scheduleManager = TaskListScheduleManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Install the tremor task in the app config. This hooks up the tremor task so that it will
        // use the appropriate factory.
         SBABridgeConfiguration.shared.addMapping(with: MCTTaskInfo(.tremor).task)
        
        // reload the schedules and add an observer to observe changes.
        scheduleManager.reloadData()
        NotificationCenter.default.addObserver(forName: .SBAUpdatedScheduledActivities, object: scheduleManager, queue: OperationQueue.main) { (notification) in
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.scheduleManager.scheduledActivities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let activity = self.scheduleManager.scheduledActivities[indexPath.item]
        cell.textLabel?.text = activity.activity.label
        cell.detailTextLabel?.text = activity.activity.labelDetail
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activity = self.scheduleManager.scheduledActivities[indexPath.item]
        
        let taskViewModel = scheduleManager.instantiateTaskViewModel(for: activity)
        let vc = RSDTaskViewController(taskViewModel: taskViewModel)
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }

    func taskController(_ taskController: RSDTaskController, didFinishWith reason: RSDTaskFinishReason, error: Error?) {

        // dismiss the view controller
        (taskController as? UIViewController)?.dismiss(animated: true, completion: nil)
        
        // Let the schedule manager handle the cleanup.
        scheduleManager.taskController(taskController, didFinishWith: reason, error: error)
        
        // Reload the table view
        self.tableView.reloadData()
    }
    
    func taskController(_ taskController: RSDTaskController, readyToSave taskViewModel: RSDTaskViewModel) {
        scheduleManager.taskController(taskController, readyToSave: taskViewModel)
    }
}
