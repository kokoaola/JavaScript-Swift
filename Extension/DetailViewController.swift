//
//  DetailViewController.swift
//  project1
//
//  Created by koala panda on 2023/03/15.
//
///画像のSaveのためには許可が必要
///プロジェクト・ナビゲーターでInfo.plistを選択し、データでいっぱいの大きなテーブルが表示されたら、その下の白いスペースで右クリックしてください。表示されるメニューから「行の追加」をクリックすると、「アプリケーション・カテゴリー」で始まる新しいオプションのリストが表示されるはずです。
///そのリストを下にスクロールして、「Privacy - Photo Library Additions Usage Description」という名前を見つけてください。これは、あなたのアプリがフォトライブラリに追加する必要があるときにユーザーに表示されるものです。右側空白部分に、アプリがフォトライブラリで何をするつもりなのかを説明するテキストを入力して、ユーザーに表示することができます。

import UIKit

protocol DestinationViewControllerDelegate: AnyObject {
    func changeProperty(value: String)
}


class DetailViewController: UITableViewController {
    var dic: [String: String]?
    var keys: [String]?
    weak var delegate: DestinationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "保存したJavaScript"
        keys = dic?.keys.sorted() // キーをソートして配列に保存します
    }
    
    ///行数の指定
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys?.count ?? 0
    }
    
    ///セルの内容の指定
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        ///メモリ節約のために見えなくなったセルの再利用をするよという設定
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        if let key = keys?[indexPath.row] {
            cell.textLabel?.text = "\(key): \(dic?[key] ?? "")" // キーと値を表示します
        }
        return cell
    }
    
    ///セルタップ時の動き
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let key = keys?[indexPath.row] {
            delegate?.changeProperty(value: dic?[key] ?? "")
            self.navigationController?.popViewController(animated: true)
        }
        }
    }
    

