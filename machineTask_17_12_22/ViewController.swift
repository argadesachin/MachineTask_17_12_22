//
//  ViewController.swift
//  machineTask_17_12_22
//
//  Created by Mac on 16/12/22.
//

import UIKit
import SDWebImage
class ViewController: UIViewController {
    
//MARK - IBOutlet connection of CollectionView And TableView
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView1: UICollectionView!
    var usersApiResponse = [userApiResponse]()
    var productsApiResponse = [productApiResponse]()
    override func viewDidLoad() {
        super.viewDidLoad()
        registerNib()
        initDataAndDelegate()
        productFetchingApi(){
            self.collectionView1.reloadData()
        }
        userFetchingApi()
    }
    
// MARK - register TableViewCell and CollectionViewCell
    func registerNib(){
        let nibName = UINib(nibName: "UserTableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "UserTableViewCell")
        
        let nibName1 = UINib(nibName: "ProductCollectionViewCell", bundle: nil)
        self.collectionView1.register(nibName1, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
    
 //MARK - initialization of data source and delegate method
    func initDataAndDelegate(){
        tableView.dataSource = self
        tableView.delegate = self
        collectionView1.dataSource = self
        collectionView1.delegate = self
    }
    
 // MARK - Fetching api by using decode method
    func productFetchingApi(completed : @escaping ()->() ){
        let urlString = "https://fakestoreapi.com/products"
        guard let url = URL(string: urlString) else {
            print("url not found")
            return
        }
        
        URLSession.shared.dataTask(with: url){data,response,error in
            if(error == nil){
                do{
                   let getJsonObject = JSONDecoder()
                    self.productsApiResponse = try! getJsonObject.decode([productApiResponse].self, from: data!)
                }catch{
                    print("error\(error)")
                }
                DispatchQueue.main.async {
                    completed()
                }
            }
        }.resume()
    }
    
 // MARK - fetching api by using serialization
    func userFetchingApi(){
       let urlString = "https://fakestoreapi.com/users"
        let url = URL(string: urlString)
        
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: request){data ,response,error in
            
            let getJsonObject = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            
            for Dictionary in getJsonObject{
                let eachDictionary = Dictionary["name"] as! [String:Any]
                let firstName = eachDictionary["firstname"] as! String
                let lastName = eachDictionary["lastname"] as! String
                
                let newObject = userApiResponse(name: Name(firstname: firstName, lastname: lastName))
                self.usersApiResponse.append(newObject)
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        dataTask.resume()
    }
}

// MARK - DataSource methof of collection view
extension ViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsApiResponse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let collectionViewCell = self.collectionView1.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as! ProductCollectionViewCell
        let imgUrl = NSURL(string: productsApiResponse[indexPath.row].image)
        collectionViewCell.imageView.sd_setImage(with: imgUrl as URL?)
        return collectionViewCell
    }
}

//MARK - Delegate And DelegateFlowLayout of collection view
extension ViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 254, height: 130)
    }
}

// MARK - DataSource Mehod of TableViewCell
extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersApiResponse.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        tableViewCell.firstNameLabel.text = usersApiResponse[indexPath.row].name.firstname
        tableViewCell.lastNameLabel.text = usersApiResponse[indexPath.row].name.lastname
        
        return tableViewCell
    }
}

//MARK - Delegate Method of TableView
extension ViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        120
    }
}


