import UIKit

//class for presenting the nominee
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
        //getting all nominee from db if exist and reload tableview
        nomineeList = dbPresenter.featchAllNominees()
        self.nomineeTableView.reloadData()
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
    //Action which opens the edit nominee view
    @IBAction func addNomineeBtnClick(_ sender: Any) {
        passingNominee = Nominee()
        performSegue(withIdentifier: "editNomineeSegueue", sender: self)
    }
    //Override the default segue for include nominee data if a row is updated
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editNomineeSegueue" {
            let viewController = segue.destination as! EditNomeneeViewController
            
            viewController.passedNominee = passingNominee
        }
    }
}
