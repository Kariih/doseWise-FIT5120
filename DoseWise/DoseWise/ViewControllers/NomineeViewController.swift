import UIKit

class NomineeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let dbPresenter = DbPresenter()
    @IBOutlet weak var nomineeTableView: UITableView!
    private var nomineeList = [Nominee]()
    private var passingNominee = Nominee()
    let cellHeight:CGFloat = 120
    var clickedCell = 0
    
    override func viewDidLoad() {
        super.viewDidLoad();
        nomineeTableView.delegate = self
        nomineeTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("featching possible nominees")
        nomineeList = dbPresenter.featchAllNominees()
        self.nomineeTableView.reloadData()
        print("view update")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nomineeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nomineeTableView.dequeueReusableCell(withIdentifier: "nomineeCell", for: indexPath)
        let nominee = nomineeList[indexPath.row]
        cell.textLabel?.text = nominee.name
        cell.detailTextLabel?.text = nominee.phoneNo
        return cell
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let edit = UITableViewRowAction(style: .normal, title: "Edit")
        { action, index in
            self.passingNominee = self.nomineeList[indexPath.row]
            self.performSegue(withIdentifier: "editNomineeSegueue", sender: self)
        }
        edit.backgroundColor = .orange
        return [edit]
    }
    
    @IBAction func addNomineeBtnClick(_ sender: Any) {
        passingNominee = Nominee()
        performSegue(withIdentifier: "editNomineeSegueue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNomineeSegueue" {
            let viewController = segue.destination as! EditNomeneeViewController
            
            viewController.passedNominee = passingNominee
        }
    }
}
