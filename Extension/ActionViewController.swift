//
//  ActionViewController.swift
//  Extension
//
//  Created by koala panda on 2023/05/10.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers


///このファイルは自動生成される

class ActionViewController: UIViewController, DestinationViewControllerDelegate {
    
    /// UITextViewのアウトレット。ユーザーが入力するスクリプトを表示・編集するためのテキストビュー
    @IBOutlet var script: UITextView!
    
    ///この2つのプロパティはSafariから送信されてくる。
    ///ページタイトルはナビゲーションバーに表示するために使うことにして、URLはプログラム内で使うため
    var pageTitle = ""
    var pageURL = ""
    
    let defaults = UserDefaults.standard
    
    var str:String? = ""
    
    ///元々のviewDidLoad内のコードは難しいので、こちらに置き換える
    override func viewDidLoad() {
        super.viewDidLoad()
        ///done()メソッドは、もともとストーリーボードからアクションとして呼び出される
        ///デフォルトのUIは古いのでコードでUIBarButtonItemを作成し、その代わりにdone()を呼び出すようにしましょう。
        ///実行ボタン
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "実行", style: .plain, target: self, action: #selector(done))
        
        ///左端の＋ボタン
        ///
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectAction))
        
        ///xtensionContext=親アプリ(safari)とのやり取りを制御する
        ///inputItemsは親アプリがエクステンションに送るデータの配列
        ///入力アイテムが存在する場合、その最初のアイテムを取得
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            /// アタッチメントが存在する場合、その最初のアイテムを取得
            ///inputItemsには添付ファイルの配列が含まれており、NSItemProviderとしてラップされて渡されます。
            if let itemProvider = inputItem.attachments?.first {
                /// アイテムをロード
                ///クロージャを使っているので、このコードは非同期に実行されることがわかります。つまり、アイテムプロバイダがデータの読み込みと送信に追われている間、このメソッドは実行され続けるのです。
                ///強参照サイクルを避けるために[weak self]と2つのパラメータを受け取る
                ///loadItem(forTypeIdentifier:)が完了すると、クロージャが呼び出され、そのデータを処理することができます
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in

                    
                    ///NSDictionaryは新しいデータ型で、Swiftでの使用頻度は低い。NSDictionaryはSwiftの辞書に似ているが、宣言が不要で保持するデータ型を知ることさえできません。それは1つでメリットとデメリットの両方であり、最新のSwift辞書が好まれる理由です。しかし、拡張機能で作業するとき、私たちはそこにあるものを気にしないので、それは間違いなく利点です
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    
                    ///loadItem(forTypeIdentifier:)を使うと、拡張機能から受け取ったデータと、発生したエラーでクロージャが呼び出されます。
                    ///この辞書には、JavaScriptから送信したデータ以外は何も入っておらず、NSExtensionJavaScriptPreprocessingResultsKeyという特別なキーに格納されています。そこで、その値を辞書から取り出して、javaScriptValuesという値に入れるのです。
                   ///JavaScriptからデータの辞書を送ったので、javaScriptValuesを再びNSDictionaryとしてタイプキャストして、キーで値を引き出せるようにしています。
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    print(javaScriptValues)
                    
                    ///javaScriptValues辞書から2つのプロパティを設定し、それらをStringとしてタイプキャストしています
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    print(String(describing: self?.pageURL ?? " "))
                    guard let str2 = self?.defaults.string(forKey:"\(String(describing: self?.pageURL ?? " "))")else {
                        return
                        
                    }
                    self?.str = str2
                    self?.script.text = self?.str
                    
                    
                    ///async()を使って、メインキューにビューコントローラのtitleプロパティを設定しています。これは、loadItem(forTypeIdentifier:)の結果として実行されるクロージャがどのスレッドでも呼び出される可能性があり、メインスレッドにいない限りUIを変更したくないためです。
                    ///この場合async()呼び出しに[weak self]は不要。すでにselfをweakと宣言したクロージャの中にいるので、この新しいクロージャはそれを使用します。
                    ///これで完了です！ユーザは拡張機能にコードを書き、「完了」をタップすると、eval()を使ってSafariでコードが実行されます。試しに、alert(document.title);というコードをエクステンションに入力してみてください。Doneをタップすると、Safariに戻り、メッセージボックスにページタイトルが表示されます。
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                    
                    
                }
            }
            
            
            ///NotificationCenterという新しいクラスを使って、キーボードの状態が変化したときに通知する
            ///舞台裏では、iOSはキーボードの変更、アプリケーションのバックグラウンドへの移行、アプリケーションが投稿するカスタムイベントなど、物事が起こったときに常に通知を送信しています。通知のオブザーバーとして自分自身を追加し、通知が発生したときに私たちの名前のメソッドが呼び出される
            
            ///キーボードを操作する場合の通知はkeyboardWillHideNotificationとkeyboardWillChangeFrameNotificationです。前者はキーボードの非表示が完了したときに送信され、後者はキーボードの状態が変化したときに表示されます（表示や非表示だけでなく、向きやQuickTypeなども含まれます）。
            
            ///keyboardWillChangeFrameNotificationがあればkeyboardWillHideNotificationは必要ないと思われるかもしれませんが、私のテストではkeyboardWillChangeFrameNotificationだけではハードウェアキーボードが接続されたことをキャッチするのに十分ではありませんでした。
            
            ///通知のオブザーバーとして登録するには、デフォルトの通知センターへのリファレンスを取得します。このメソッドは、通知を受け取るべきオブジェクト（self）、呼び出すべきメソッド、受け取りたい通知、監視したいオブジェクトの4つのパラメータを受け取ります。最後のパラメータにはnilを渡します。"誰が通知を送るかは気にしない "という意味です。
            // NotificationCenterのインスタンスを取得
            let notificationCenter = NotificationCenter.default
            // キーボードが隠れるとき、またはフレームが変わるときにadjustForKeyboardメソッドを実行するように設定
            notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }

    }
    
    
    
    ///拡張コンテキストでcompleteRequest(returningItems:)を呼び出すと、拡張は閉じられ、親アプリに戻ります。ただし、指定した項目（現在のコードでは送信された項目と同じもの）は親アプリに返されます。
    
    ///私たちのようなSafari拡張機能では、ここで返すデータはAction.js JavaScriptファイルのfinalize()関数に渡されるので、ユーザーがテキストビューに入力したテキストを渡すようにdone()メソッドを修正します。
    
    
    @IBAction func done() {
        print(String(describing:pageURL))
        defaults.set("\(script.text ?? "")", forKey: "\(String(describing:pageURL))")
        
        ///アイテムをホストする新しいNSExtensionItemオブジェクトを作成します。
        ///キー "customJavaScript" とスクリプトの値を含む辞書を作成します。
        ///その辞書を、キー NSExtensionJavaScriptFinalizeArgumentKey を持つ別の辞書に入れる。
        ///大きな辞書を、型識別子 kUTTypePropertyList を持つ NSItemProvider オブジェクトの中に包みます。
        ///その NSItemProvider を NSExtensionItem にアタッチメントとして配置します。
        ///completeRequest(returningItems:)を呼び、NSExtensionItemを返す。
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text ?? ""]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        
        extensionContext?.completeRequest(returningItems: [item])
        
    }
    
    
    
    @objc func adjustForKeyboard(notification: Notification) {
    ///adjustForKeyboard()メソッドは複雑ですが、それはかなり多くの作業を行うためです。まず、Notification型のパラメータを受け取ります。これには、通知の名前と、userInfoと呼ばれる通知固有の情報を含むDictionaryが含まれます。
    
    ///キーボードを扱う場合、このDictionaryにはUIResponder.keyboardFrameEndUserInfoKeyというキーが含まれ、キーボードのアニメーションが終了した後のフレームを知らせます。これはNSValue型になり、CGRect型になります。CGRect構造体は、CGPointとCGSizeの両方を保持するので、矩形を記述するために使用することができます。
    
    ///Objective-Cの特徴の1つは、配列や辞書にCGRectのような構造体を含めることができないことです。そこでAppleはNSValueという特別なクラスを用意し、構造体のラッパーとして機能させて、辞書や配列に入れることができるようにしました。NSValueオブジェクトを取得していますが、その中にCGRectが含まれていることが分かっているので、そのcgRectValueプロパティを使って値を読み取っています。
    
    ///キーボードの正しいフレームを取り出したら、その矩形をビューの座標に変換する必要があります。これは、回転がフレームに考慮されていないためで、ユーザーが横向きの場合、幅と高さが反転してしまいますが、convert()メソッドを使用することで修正されます。
    
    ///adjustForKeyboard()メソッドで次に行うべきことは、テキストビューのcontentInsetとscrollIndicatorInsetsを調整することです。この2つは、テキストビューの端をくぼませて、制約がビューの端から端まで残っていても、より小さなスペースを占めているように見せるものです。
    
    ///最後に、テキストビューをスクロールさせて、テキスト入力カーソルを表示させます。テキストビューが縮小した場合、このカーソルは画面の外に出てしまうので、スクロールして再び見つけることで、ユーザーエクスペリエンスを損なわないようにしています。
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        
        ///テキストビューのインセットの設定はUIEdgeInsets構造体を使用して行われ、4つのエッジすべてのインセットが必要です。ここでは、テキストビューのコンテンツのインセットをscrollIndicatorInsetsに使用して、時間を節約しています。
        
        ///UIKeyboardWillHideのチェックを入れることで、ハードウェアキーボードが接続されている場合に、インセットをゼロに設定
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    
    func showDetailView(_ action: UIAlertAction){
        if defaults.object(forKey:"SavedDict") == nil{
            let dic = ["おみくじ":"const omi = [`大吉`,`中吉`,`小吉`,`吉`,`凶`,`カトキチ`]; alert(`今日の運勢：` + omi[Math.floor(Math.random() * 5)]);", "スクリーンサイズを取得": "alert(`縦` + screen.height + `\n横` + screen.width)"]
            defaults.set(dic, forKey: "SavedDict")
        }
        
        let dic = defaults.object(forKey:"SavedDict") as? [String: String] ?? [:]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.dic = dic
            vc.delegate = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func showTextFieldAlert(_ action: UIAlertAction){
        var dic = defaults.object(forKey:"SavedDict") as? [String: String] ?? [:]
        let ac = UIAlertController(title: "Script名を入力", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "保存", style: .default) { [weak self, weak ac] action in
            guard let scriptName = ac?.textFields?[0].text else { return }
            dic[scriptName] = self?.script.text ?? ""
            self?.submit(dic)
        }
        ac.addAction(submitAction)
        let cansel = UIAlertAction(title: "cansel", style: .cancel)
        ac.addAction(cansel)
        present(ac, animated: true)
    }
    
    
    ///メニューアラート
    @objc func selectAction(){
        let alert = UIAlertController(title: "メニュー",
                                      message: "実行するアクションを選択してください。",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "保存したScript一覧", style: .default, handler: showDetailView))
        
        alert.addAction(UIAlertAction(title: "名前をつけて保存", style: .default, handler: showTextFieldAlert))
        
        alert.addAction(UIAlertAction(title: "キャンセル", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func submit(_ dic: [String: String]) {
        print(dic)
        defaults.set(dic, forKey: "SavedDict")
        print("OK")
    }
    
    
    ///このコードでは、遷移先のセルがタップされたときにdelegateプロパティ経由でchangeProperty(value:)メソッドを呼び出します。このdelegateは、SourceViewControllerのインスタンスになります。したがって、このメソッドの呼び出しは、SourceViewControllerのpropertyプロパティの値を変更します。
    func changeProperty(value: String) {
        print(value)
        script.text = value
        script.reloadInputViews()
    }
    
}

