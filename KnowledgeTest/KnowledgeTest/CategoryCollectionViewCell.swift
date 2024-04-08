//
//  CategoryCollectionViewCell.swift
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tableView: UITableView!
    var rankingData: [Record] = []
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: CategoryCell.self), bundle: nil),
                           forCellReuseIdentifier: String(describing: CategoryCell.self))
    }
    
    func setupData(data: [Record]) {
        let sorted = data.sorted { $0.point > $1.point }
        self.rankingData = Array(sorted.prefix(5))
    }

}

extension CategoryCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CategoryCell.self), for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        cell.nameLb.text = rankingData[indexPath.row].name
        cell.pointLb.text = "\(rankingData[indexPath.row].point)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rankingData.count
    }
}
