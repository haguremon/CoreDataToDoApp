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
        let createTaskAction = UIAlertAction(title: "createTask", style: .default) { [weak self] _ in
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
       
        switch sender.selectedSegmentIndex {
        case 0:
            tableView.isEditing = false
        case 1:
            tableView.isEditing = true
        case 2:
            cellEditViewSegment.isMomentary = true

            do {
           
                
                let sort1 = NSSortDescriptor(key: "date", ascending: true)
                
                fetchRequest.sortDescriptors = [sort1]
            
                tasks = try context.fetch(fetchRequest)
               // try context.save()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch  {
                print(error)
            }

            print("")
        case 3:
            cellEditViewSegment.isMomentary = true
            do {
                
                let sort1 = NSSortDescriptor(key: "date", ascending: false)
                fetchRequest.sortDescriptors = [sort1]
                tasks = try context.fetch(fetchRequest)
                try context.save()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            
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
    //上と似てるから変更できそう
    func upTasksMemo(task: Tasks, upMemo: String){
        task.memo = upMemo
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
//    @IBAction func exit(segue: UIStoryboardSegue){
//        let vc2 = segue.destination as! DetailsViewController
//        upTasksMemo(task: vc2.tasks, upMemo: vc2.memoTextView.text)
//
//    }

    @IBAction func ascendingfalseBtn(_ sender: UIButton) {
        let fetchRequest = Tasks.fetchRequest() as NSFetchRequest<Tasks>
        let sort1 = NSSortDescriptor(key: "date", ascending: false)
       // let sort2 = NSSortDescriptor(key: "task", ascending: false)
       // let sort3 = NSSortDescriptor(key: "memo", ascending: false)
        fetchRequest.sortDescriptors = [sort1]

        do {
            let tasks = try context.fetch(fetchRequest)

            tasks.forEach {
                self.tasks.first?.date = $0.date
                self.tasks.first?.task = $0.task
                self.tasks.first?.memo = $0.memo
            }
            
            
            try context.save()
            
           
            createTasksDataAll()
        
        } catch  {
            print(error)
        }
    
    
    
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

