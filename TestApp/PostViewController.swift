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
    
    private var photoTypeDtoOut = [PhotoTypeDtoOut]()
    private var tableView: UITableView!
    private var id : Int32?
    
    private var currentPage: Int32 = 0
    private var totalPages: Int32 = 1
    private var isLoadingData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getList(page: 1)
        setupTableView()
    }
    
    private func createSpinerFooter() -> UIView {
        let footerView = UIView(frame: CGRect (x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
    
    private func getList(page: Int32) {
        guard !isLoadingData else { return }
        isLoadingData = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            NetworkService.fetchList(page: page) { [weak self] result, error in
                guard let result = result else {
                    self?.isLoadingData = false
                    return
                }
                self?.totalPages = result.totalPages ?? 1
                if page == 0 {
                    self?.photoTypeDtoOut = result.content ?? []
                } else {
                    self?.photoTypeDtoOut.append(contentsOf: result.content ?? [])
                }
                self?.tableView.reloadData()
                self?.isLoadingData = false
                self?.tableView.tableFooterView = nil
            }
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

extension PostViewController: UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height - scrollView.frame.size.height
        
        if offsetY > contentHeight - 50, !isLoadingData, currentPage < totalPages - 1 {
            currentPage += 1
            self.tableView.tableFooterView = createSpinerFooter()
            getList(page: currentPage)
        }
    }
}





