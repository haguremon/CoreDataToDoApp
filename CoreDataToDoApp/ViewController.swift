//
//  ViewController.swift
//  CoreDataToDoApp
//
//  Created by IwasakIYuta on 2021/07/11.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var cellEditViewSegmentControl: UISegmentedControl!
    
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
                //クロージャないでselfに参照するのでweakをつけて弱参照にしてる
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
}
extension ViewController: UITextFieldDelegate{
    //keyBordのReturnが押された時の処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskTextField.resignFirstResponder()
        newTaskData(task: taskTextField.text!)
        taskTextField.text = ""
        tableView.reloadData()
        return true
    }
}

