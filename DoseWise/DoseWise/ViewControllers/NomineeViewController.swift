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
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = nomineeTableView.dequeueReusableCell(withIdentifier: "nomineeCell", for: indexPath)
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.lineBreakMode = .byWordWrapping
//        cell.textLabel?.text = "\(nomineeList[indexPath.item].name!) - \(nomineeList[indexPath.item].phoneNo!)"
//        return cell
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nomineeTableView.dequeueReusableCell(withIdentifier: "nomineeCell", for: indexPath)
        let nominee = nomineeList[indexPath.row]
        cell.textLabel?.text = nominee.name
        cell.detailTextLabel?.text = nominee.phoneNo
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        passingNominee = nomineeList[indexPath.row]
        performSegue(withIdentifier: "editNomineeSegueue", sender: self)
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
