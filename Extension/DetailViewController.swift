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

class DetailViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pictures"
        
    }

}
