//
//  ViewController.swift
//  CoreDataToDoApp
//
//  Created by IwasakIYuta on 2021/07/11.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskTextField: UITextField!
    
    @IBOutlet weak var cellEditViewSegment: UISegmentedControl!
    //()でAppDelegateを使えるようにしてそれから下でNSManagedObjectContextを作成する//永久的のコンテント
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var tasks = [Tasks]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        taskTextField.delegate = self
        createTasksDataAll()
        //tableView.reloadData()
    }
    @IBAction func taskAddBarButton(_ sender: UIBarButtonItem) {
        let dalog = UIAlertController(title: "taskAdd", message: "タスクを追加します", preferredStyle: .alert)
        dalog.addTextField(configurationHandler: nil)//dalogにTextFieldを加える//アクションシートにはテキストフィールドは加えることができない
        let createTaskAction = UIAlertAction(title: "createTask", style: .default) {[weak self] _ in
            //field⇨dalogでtextFieldが追加されてるか判断して、text⇨textFieldsのテキストを取得する
            guard let field = dalog.textFields?.first, let text = field.text, !text.isEmpty else{
                return
            }
            //クロージャ内でselfに参照するのでweakをつけて弱参照にしてる
            self?.newTaskData(task: text)
        }
        
        dalog.addAction(createTaskAction)
        present(dalog, animated: true, completion: nil)
    }
    @IBAction func createButton(_ sender: UIButton) {
        guard let task = taskTextField.text, !task.isEmpty else { return }
        newTaskData(task: task)
        //tableView.reloadData()
    }
    
    @IBAction func cellEditViewSegmentControl(_ sender: UISegmentedControl) {
        let fetchRequest = Tasks.fetchRequest() as NSFetchRequest<Tasks>
        //let predicate: NSPredicate? = nil
        //fetchRequest.predicate = predicate
        //fetchRequest.includesSubentities = false
        //fetchRequest.entity = Tasks.entity()
        switch cellEditViewSegment.selectedSegmentIndex {
        case 0:
            tableView.isEditing = false
        case 1:
            tableView.isEditing = true
        case 2:
            
            do {
                let sort = NSSortDescriptor(key: "task", ascending: true)
                fetchRequest.sortDescriptors = [sort]
            
                self.tasks = try context.fetch(fetchRequest)
                
                //self.createTasksDataAll()
                self.tableView.reloadData()
            } catch  {
                print(error)
            }

            print("")
        case 3:
            do {
              
                let sort = NSSortDescriptor(key: "task", ascending: false)
                fetchRequest.sortDescriptors = [sort]
                self.tasks = try context.fetch(fetchRequest)
                //self.createTasksDataAll()
                self.tableView.reloadData()
                print(tasks)
            } catch  {
                print(error)
            }
            print("")
        default:
            print("")
        }
    
    }
    
    //coreDataのCRUD等
    func createTasksDataAll(){
        do{
         tasks = try context.fetch(Tasks.fetchRequest())//TasksのfetchRequest()でTasksのデータを全部取得することができる
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print(error)
        }
    }
    func newTaskData(task: String){
        let newTask = Tasks(context: context)
        newTask.task = task
        newTask.date = Date()
        do {
            try context.save()
            createTasksDataAll()
        } catch  {
            print(error)
        }
        
    }
    func upDateTasksData(task: Tasks, newTask: String){
        task.task = newTask
        do {
            try context.save()
            createTasksDataAll()
        } catch  {
            print(error)
        }
    }
    func deleteTasksData(task: Tasks){
        context.delete(task)
        do {
            try context.save()
            createTasksDataAll()
        } catch  {
            print(error)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}




extension ViewController: UITextFieldDelegate{
    //keyBordのReturnが押された時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        newTaskData(task: taskTextField.text!)
        taskTextField.text = ""
        //tableView.reloadData()
        return true
    }
}

