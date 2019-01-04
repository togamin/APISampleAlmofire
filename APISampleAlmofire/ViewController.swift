//
//  ViewController.swift
//  APISampleAlmofire
//
//  Created by Togami Yuki on 2019/01/03.
//  Copyright © 2019 Togami Yuki. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var queryTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var siteTitle:[String] = []
    var siteURL:[String] = []
    
    //データ取得最大数
    var getNum = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TextFieldのデフォルト値
        queryTextField.text = ""
        
        tableView.delegate = self
        tableView.dataSource = self
        queryTextField.delegate = self
        
    }
    
    //ブログ、ニュースサイトの情報を取得する関数。
    func getInfo(resultNum:Int,query:String){
        //ブログ、ニュースサイトの情報を取得するAPI
        let urlString:String = "http://cloud.feedly.com/v3/search/feeds?count=" + String(resultNum) + "&query=" + query
        
        //エンコードする。ひらがな、カタカナだと上手くいかないことがある。
        let encodeURL:String = urlString.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)!
        
        //データの取得
        //URLにアクセスし、返ってきた値を受け取る。
        //返ってきた値をプログラムで扱える形に変換
        Alamofire.request(encodeURL).responseJSON{ response in
            
            //何も返ってこなかった場合は、処理を抜け。
            //エラーが発生した時に処理を終了する。アプリのクラッシュを防ぐ。
            guard let object = response.result.value else {
                return
            }
            
            //取得したデータとJSON型に変換後のデータ
            print("memo:-----------------------")
            print("memo:取得したデータ",object)
            let json = JSON(object)
            print("memo:-----------------------")
            print("memo:JSON形式に変換後",json)
            print("memo:-----------------------")
            
            //forEachでそれぞれのデータにアクセスする。
            json["results"].forEach { (_, json) in
                print("memo:サイトTitle",json["title"].stringValue)
                print("memo:WebサイトURL",json["website"].stringValue)
               
               //配列に情報を入れる
                self.siteTitle.append(json["title"].stringValue)
                self.siteURL.append(json["website"].stringValue)
            }
            print("memo:テーブルリロード")
            self.tableView.reloadData()
        }
    }
}

//キーボードに関する関数
extension ViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        siteTitle = []
        siteURL = []
        getInfo(resultNum:getNum,query:queryTextField.text!)
        queryTextField.endEditing(true)
        return true
    }
}

//テーブルViewに関する関数
extension ViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return siteTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = siteTitle[indexPath.row]
        cell.detailTextLabel?.text = siteURL[indexPath.row]
        return cell
    }
}


