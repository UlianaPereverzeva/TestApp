//
//  ListTableViewController.swift
//  TestApp
//
//  Created by ульяна on 13.12.23.
//
import UIKit
import Kingfisher
import Alamofire

final class PostViewController: UIViewController {
    
    var photoTypeDtoOut = [PhotoTypeDtoOut]()
    var tableView: UITableView!
    var id : Int32?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getList()
        setupTableView()
    }
    
    private func getList() {
        NetworkService.fetchList { [weak self] result, error in
            guard let result = result?.content else { return }
            self?.photoTypeDtoOut = result
            self?.tableView.reloadData()
        }
    }
    
    private func setupTableView() {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        self.tableView = tableView
    }
}

extension PostViewController: UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoTypeDtoOut.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as?
                TableViewCell else {
            return UITableViewCell()
        }
        let list = photoTypeDtoOut[indexPath.row]
        cell.configure(photoTypeDtoOut: list)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.id = photoTypeDtoOut[indexPath.row].id
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                let id = self.id?.description ?? ""
                let name = "Переверзева Ульяна"
                
                NetworkService.postPhoto(id: id, name: name, image: image) { result in
                    switch result {
                    case .success(let response):
                        print("Success: \(response)")
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}



