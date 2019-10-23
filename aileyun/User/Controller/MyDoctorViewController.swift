//q
import SVProgressHUD
import MJRefresh

class MyDoctorViewController: BaseViewController {

    let reuseIdentifier = "reuseIdentifier"
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace + 44, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 44))
        t.backgroundColor = klightGrayColor
        t.dataSource = self
        t.delegate = self
        t.separatorStyle = .none
        t.tableFooterView = UIView()
        self.view.addSubview(t)
        return t
    }()
    
    var doctorArr : [DoctorAttentionModel]?{
        didSet{
            tableV.reloadData()
        }
    }
    
    var currentPage = 1
    
    var hasNext = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "关注的医生"
        
        tableV.register(DoctorAttentionTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        let footV = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(MyDoctorViewController.requestData))
        tableV.mj_footer = footV
        
        requestData()
    }

    func requestData(){
        
        guard hasNext == true else{
            self.tableV.mj_footer.endRefreshing()
            HCShowError(info: "没有更多信息")
            return
        }
        
        
        SVProgressHUD.show()
        let paId = UserManager.shareIntance.HCUser?.id?.intValue
        HttpRequestManager.shareIntance.HC_attentionDocList(patientId: paId!, pageNum: String.init(format: "%d", currentPage)) { [weak self](success, hasNext, arr, msg) in
            if success == true{
                if let doctorArr = self?.doctorArr {
                    let tempArr = doctorArr + arr!
                    self?.doctorArr = tempArr
                }else{
                    self?.doctorArr = arr
                }
                self?.hasNext = hasNext
                if hasNext {
                    self?.currentPage += 1
                    SVProgressHUD.dismiss()
                }else{
                    HCShowInfo(info: "数据已全部加载")
                }
            }else{
                HCShowError(info: msg)
            }
            self?.tableV.mj_footer.endRefreshing()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyDoctorViewController : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return doctorArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! DoctorAttentionTableViewCell
        cell.model = doctorArr?[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DoctorIntroductionController()
        vc.doctorId = (doctorArr?[indexPath.row].doctorId?.intValue)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
