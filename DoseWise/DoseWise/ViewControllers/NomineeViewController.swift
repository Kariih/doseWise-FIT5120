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
    
    // This is the call for medicine search. this needs to be called in this fashion in the relevant controller. i've added it here just for testing purpose
    //    @IBAction func Mytext_Edit(_ sender: UITextField) {
    //
    //        if (Mytext.text != "")
    //        {
    //          meds.searchmeds(searchstring: Mytext.text!){(Searchresponse) in
    //            if Searchresponse.count>0 { self.Mytext.text = Searchresponse.joined(separator: ":")} //Assigne Search Res
    //            } //Medsearch call
    //        }
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nomineeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = nomineeTableView.dequeueReusableCell(withIdentifier: "nomineeCell", for: indexPath)
        cell.textLabel?.text = "\(nomineeList[indexPath.item].name!) - \(nomineeList[indexPath.item].phoneNo!)"
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
