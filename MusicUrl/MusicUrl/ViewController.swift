//
//  ViewController.swift
//  MusicUrl
//
//  Created by Mac on 08/06/22.
//
import UIKit
class ViewController: UIViewController {
    //MARK: Outlet
    @IBOutlet weak var musicDataTableView: UITableView!
    var musicDataArray: [ModelClass] = []
    //MARK: Lifecycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.musicDataTableView.dataSource = self
        self.musicDataTableView.delegate = self
        let urlString = "https://itunes.apple.com/search/media=music&entity=song&term=arjitsingh"
        guard let url = URL(string: urlString) else {
            print("URL is Invalid")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            print("Data received from URL is: \(String(describing: data))")
            if let error = error {
                print("Error received from URL is: \(error)")
            } else {
                guard let response = response as? HTTPURLResponse,
                      response.statusCode == 200,
                      let data = data else {
                          print("Data is invalid OR Status code is not proper")
                          return
                      }
                do{
                    
                    guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else{
                        print("Json not expected format")
                        return
                    }
                    guard let json = jsonObject["results"] as? [[String: Any]] else {
                        print("Dictionary not contain result key....")
                        return
                    }
                    for musicDetail in json{
                        let musicDetail = musicDetail as? [String: Any]
                        let postArtistId = musicDetail?["artistId"] as? Int
                        let postArtistName = musicDetail?["artistName"] as? String
                        let postTrackId = musicDetail?["trackId"] as? Int
                        let postTrackName = musicDetail?["trackName"] as? String
                        let postPreviewUrl = musicDetail?["previewUrl"] as? String
                        
                        let music = ModelClass(artistId: postArtistId!,
                                               artistName: postArtistName!,
                                               trackId: postTrackId!,
                                               trackName: postTrackName!,
                                               preViewUrl: postPreviewUrl!)
                        self.musicDataArray.append(music)
                        DispatchQueue.main.async {
                            self.musicDataTableView.reloadData()
                        }
                    }
                    
                }catch let myError {
                    print("Got error while converting Data to JSON - \(myError.localizedDescription)")
                }
            }
            
        }
        
        dataTask.resume()
    }
}
//MARK: DataSource Method
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        musicDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.musicDataTableView.dequeueReusableCell(withIdentifier: "MusicDataTableViewCell", for: indexPath) as? MusicDataTableViewCell else{
            return UITableViewCell()
        }
        cell.artistIdLabel.text = String(musicDataArray[indexPath.row].artistId as Int)
        cell.artistNameLabel.text = musicDataArray[indexPath.row].artistName
        cell.trackIdLabel.text = String(musicDataArray[indexPath.row].trackId as Int)
        cell.trackNameLabel.text = musicDataArray[indexPath.row].trackName
        cell.preViewURL = musicDataArray[indexPath.row].preViewUrl
        return cell
    }
}
//MARK: Delegate Methods
extension ViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        250
    }
    private func displayalert(message: String){
        let dialogMessage = UIAlertController(title: "URL", message: message, preferredStyle: .alert)
        
        let edit = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        dialogMessage.addAction(edit)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        displayalert(message: self.musicDataArray[indexPath.row].preViewUrl)
    }
}

