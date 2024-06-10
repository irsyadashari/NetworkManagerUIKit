//
//  ViewController.swift
//  NetworkManagerSampleUIKit
//
//  Created by Irsyad Ashari on 21/04/24.
//

import UIKit

struct ListViewModel {
    private var items: [Item] = []
    
    mutating func set(_ items: [Item]) {
        self.items = items
    }
    
    func getItems() -> [Item] {
        return items
    }
}

struct Item: Codable {
    let id: Int
    let text: String
    let imageURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case text
        case imageURL
    }
}

class ViewController: UIViewController {
    private var viewModel = ListViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       setupView()
        
        let endpoint = TestAPI.get(())
        
        NetworkManager.request(endpoint: endpoint) { [weak self] (result: Result<[Item], Error>) in
            switch result {
            case .success(let response):
                self?.viewModel.set(response)
                print(response)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
               
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func setupView() {
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.reuseIdentifier)
        tableView.dataSource = self
//        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }

}

//extension ViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("selected row : \(indexPath.row)")
//    }
//}
extension ViewController: ImageTableViewCellDelegate {
    func didTapImage(index: Int) {
        print("image is tapped on row \(index)")
        let queue = OperationQueue()

        let operation1 = BlockOperation {
            print("Starting operation 1")
            sleep(3)
            print("finished operation 1")
        }

        let operation2 = BlockOperation {
            print("Starting operation 2")
            sleep(1)
            print("finished operation 2")
        }

        queue.addOperation(operation1)
        operation2.addDependency(operation1)
        queue.addOperation(operation2)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.reuseIdentifier, for: indexPath) as! ImageTableViewCell
        let item = viewModel.getItems()[indexPath.row]
        cell.configure(imageURL: item.imageURL, text: item.text)
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    
    
}

