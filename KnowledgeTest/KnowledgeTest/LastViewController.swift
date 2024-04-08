//
//  LastViewController.swift
//  Le'Quiz
//

import UIKit



class LastViewController: UIViewController {

    @IBOutlet var sectionButton: [UIButton]!
    @IBOutlet var sectionDividerView: [UIView]!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var tryAgain: UIButton!
    var message = ""
    var currentTag: Int = 0 {
        didSet {
            self.configSectionUI()
        }
    }
    var showRank: Bool = false
    var ranks: [[Record]] = []
    override func viewDidLoad() {
         super.viewDidLoad()
        tryAgain.display()
        let easyRanks = RecordManager.shared.easyData
        ranks.append(easyRanks)
        let mediumRanks = RecordManager.shared.mediumData
        ranks.append(mediumRanks)
        let hardRanks = RecordManager.shared.hardData
        ranks.append(hardRanks)
        setupCollectionView()
        if (count <= 5)
        {
            message = "You need to try harder"
        }
        else if (count <= 7)
        {
            message = "Good Job!"
        }
        else if (count <= 9)
        {
            message = "Excellent Work!"
        }
        else if (count == 10)
        {
            message = "You are a genius!"
        }
        upperLabel.text = "\(name), your score is"
        
        lowerLabel.text = """
                          \(String(count))/10
                          \(message)
                          """
        if showRank {
            upperLabel.text = "HIGH SCORE!!!"
            lowerLabel.isHidden = true
        } else {
            lowerLabel.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    
    func setupCollectionView() {
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier:  "CategoryCollectionViewCell")
        self.categoryCollectionView.reloadData()
    }
    
    func configSectionUI() {
        sectionButton.forEach { [weak self] button in
            if button.tag == self?.currentTag {
                button.setTitleColor(.black, for: .normal)
            } else {
                button.setTitleColor(.lightGray, for: .normal)
            }
        }
        sectionDividerView.forEach { [weak self] view in
            view.isHidden = view.tag != self?.currentTag
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTapSection(_ sender: UIButton) {
        self.categoryCollectionView.scrollToItem(at: IndexPath(item: sender.tag, section: 0), at: .left, animated: true)
        self.currentTag = sender.tag
    }
    
    @IBAction func reDo(sender: UIButton) {
        self.dismiss(animated: true)
        count = 0
    }
}

extension LastViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as? CategoryCollectionViewCell else {
           return UICollectionViewCell()
        }
        cell.setupData(data: ranks[indexPath.item])
        return cell
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        self.currentTag = pageIndex
    }
}
