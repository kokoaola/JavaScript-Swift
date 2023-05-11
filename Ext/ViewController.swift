//
//  ViewController.swift
//  Ext
//
//  Created by koala panda on 2023/05/10.
//

import UIKit

//エクステンションを出荷する場合は、アプリを出荷する必要があります。エクステンションは親アプリの中で出荷されます。

///アクションエクステンションは、SafariのUI内に表示されます。これにより、ユーザーは簡単にそれらを発見することができます。
///Safariの拡張機能は]ユーザーインターフェイスを持たないエクステンションを作ることは可能です。

///手順1
///新しいエクステンションを始めるには、「ファイル」メニューから「新規作成」＞「ターゲット」を選択します。テンプレートの選択を求められたら、iOS  > Action Extensionを選択し、Nextをクリックします。名前は「Extension」とし、Action Typeが「Presents User Interface」に設定されていることを確認し、Finishをクリックします。
///新しいAction Extensionターゲットを作成することで、プロジェクト内で管理するソースコードの別のチャンクが効果的に作成されます。
///アプリの中に拡張機能を作成すると、Xcodeはそのスキームを有効にするかどうかを尋ねます。Do not show this message again "ボックスをチェックし、Activateをクリックします。この変更により、コードを実行すると、実際にエクステンションが起動するようになります。
///Xcodeがエクステンションフォルダの中に2つのファイルを与えていることがわかります： ActionViewController.swiftとMainInterface.storyboardです。

///手順２
///Info.plist（プロパティリスト）があり、AppやExtensionに関するメタデータ（言語、バージョン番号など）が含まれている
///拡張機能の場合、plistにはどのようなデータを受け入れ、どのように処理すべきかも記述されています。
///設定
///NSExtensionの開示インジケータを開く：NSExtensionAttributes、NSExtensionMainStoryboard、NSExtensionPointIdentifierが表示される
///NSExtensionAttributesの矢印を開く
///１NSExtensionActivationRuleのValueをStringからDictionaryに変更する
///２NSExtensionActivationRuleの開示矢印を開き、+をクリックし「NSExtensionActivationSupportsWebPageWithMaxCount」を追加します。TypeはString、Valueは1（この値を辞書に追加することで、画像やその他のデータタイプではなくウェブ・ページのみを受信する）
///３NSExtensionAttributes行を選択し+をクリック。newItemを「NSExtensionJavaScriptPreprocessingFile」に置き換えて、Valueを「Action」に設定。これで拡張機能が呼び出されたときに、アプリバンドルにあるAction.jsというJavaScriptプリプロセッシングファイルを実行される


///手順３
///ExtensionファイルをでCmd+N　iOS > その他 > Emptyを選び、Action.jsという名前をつけます。
///Runする際にSafariを選択する。ページを開いてシェアボタンから拡張機能を選べる
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

