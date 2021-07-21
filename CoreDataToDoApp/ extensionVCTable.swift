//
//   extensionVCTable.swift
//  CoreDataToDoApp
//
//  Created by IwasakIYuta on 2021/07/20.
//

import Foundation
import UIKit
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = tasks[indexPath.row].task
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let dalogSheet = UIAlertController(title: "taskAdd", message: "", preferredStyle: .actionSheet)
        dalogSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        dalogSheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { [weak self] _ in
            let dalog = UIAlertController(title: "Edit", message: "TaskEdit", preferredStyle: .alert)
            dalog.addTextField(configurationHandler: nil)
            dalog.textFields?.first?.text = task.task
            let EditTask = UIAlertAction(title: "EditTask", style: .default) {[weak self] _ in
                //fieldでdalogでtextFieldが追加されてるか判断して⇨textでtextFieldsのテキストを取得する
                guard let field = dalog.textFields?.first, let editText = field.text, !editText.isEmpty else{
                    return
                }
                //クロージャ内でselfに参照するのでweakをつけて弱参照にしてる
                self?.upDateTasksData(task: task, newTask: editText)
            }
            dalog.addAction(EditTask)
            self?.present(dalog, animated: true)
        
        }))
        dalogSheet.addAction(UIAlertAction(title: "delete", style: .destructive, handler: {[weak self] _ in
            self?.deleteTasksData(task: task)

        }))
        present(dalogSheet, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete //デリートで指定
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            deleteTasksData(task: tasks[indexPath.row])//tasksの選択されたセルをタスクから消す
            tableView.deleteRows(at: [indexPath], with: .fade)//fadeで消す
            tableView.endUpdates()
        }
    }
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "vc2") as! DetailsViewController
        vc.tasks = tasks[indexPath.row]
        vc.task = tasks[indexPath.row].task!
        vc.create = tasks[indexPath.row].date!
        vc.memo = tasks[indexPath.row].memo ?? "特になし"
        present(vc, animated: true)
    }
    //canMoveRowAtでセルの動かしを許可
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return true
    }
    //moveRowAtで並び替え
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        context.delete(tasks[sourceIndexPath.row])
        context.insert(tasks[destinationIndexPath.row])
        do {
            try context.save()
            createTasksDataAll()
        } catch {
            print(error)
        }
    
    }
}

