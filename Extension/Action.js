//独自の前処理JavaScriptは、Swiftコードの前に実行されます。これは、ページに関するデータを送信できる場所です。
//私たちのSwift拡張が終了したとき、私たちはJavaScriptに値を送り返すことができます。送り返したものはすべて、私たちのアクションファイルで利用できるようになります。


//2つの関数があります：run()とfinalize()。
//最初の関数は拡張機能が実行される前に呼ばれ、もう1つは実行された後に呼ばれます。

//問題があるのですか？ある読者は、XcodeがAction.jsをプロジェクトにコピーするのではなく、コンパイルしようとしたため、拡張機能を実行しようとしたときに問題が発生したと報告しています。

//プロジェクトナビゲータからプロジェクトを選択し、ターゲットのリストからエクステンションを選択します（ここまでの私の指示に従えば、エクステンションと呼ばれるだけです）。次に Build Phases タブを選択し、Compile Sources と Copy Bundle Resources を開いてください。

//正しく動作していれば、Copy Bundle Resourcesの下にCompile SourcesではなくAction.jsが表示されているはずです。もしそうでない場合は、ドラッグして移動することができます。


var Action = function() {};

Action.prototype = {
    
///アクセスしたURLとページのタイトルの2つのデータを拡張機能に送信するようにします。
    ///"iOSにJavaScriptの前処理が終わったことを伝え、このデータ辞書を拡張機能に渡す。"
    //送信されるデータには「URL」と「title」というキーがあり、値にはページURLとページタイトルが入ります。
run: function(parameters) {
    parameters.completionFunction({"URL": document.URL, "title": document.title });
},
    
finalize: function(parameters) {
    var customJavaScript = parameters["customJavaScript"];
    eval(customJavaScript);
}

    
};

var ExtensionPreprocessingJS = new Action
