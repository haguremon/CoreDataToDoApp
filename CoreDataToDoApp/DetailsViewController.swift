//
//  DetailsViewController.swift
//  CoreDataToDoApp
//
//  Created by IwasakIYuta on 2021/07/19.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var createLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    
    @IBOutlet weak var memoTextView: UITextView!
    
    var create = Date()
    var task = ""
    var tasks = Tasks()
    var memo = ""
    func cretaedAt(create: Date) -> String{
        let f = DateFormatter()
        f.setTemplate(.full)
        return f.string(from: create) + "に作成されました"
    }
   
    //create = f.string(from: create) + "に作成されました"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createLabel.text = cretaedAt(create: self.create)
        taskLabel.text = task
        memoTextView.text = memo
    }
    
    @IBAction func returnButton(_ sender: UIButton) {
        guard !memoTextView.text.isEmpty   else {
            return
        }
//        let vc = self.presentingViewController as! ViewController
        let vc = storyboard?.instantiateViewController(identifier: "vc") as! ViewController
       vc.upTasksMemo(task: tasks, upMemo: memoTextView.text)
       present(vc, animated: true)
        //dismiss(animated: true)

    }
    
   
}





extension DateFormatter {
    enum Template: String {
        case date = "yMd"     // 2021/1/1
        case time = "Hms"     // 12:39:22
        case full = "yMdkHms" // 2021/1/1 12:39:22
        case onlyHour = "k"   // 17時
        case era = "GG"       // "西暦" (default) or "平成" (本体設定で和暦を指定している場合)
        case weekDay = "EEEE" // 日曜日
    }

    func setTemplate(_ template: Template) {
        // optionsは拡張用の引数だが使用されていないため常に0
        dateFormat = DateFormatter.dateFormat(fromTemplate: template.rawValue, options: 0, locale: .current)
    }


}
