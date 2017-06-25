//
//  TraitsViewController.swift
//  Music Mate
//
//  Created by John on 4/9/17.
//  Copyright © 2017 Bruce32. All rights reserved.
//

import Cocoa

class FeaturesViewController: NSViewController {
	
	var api: SpotifyAPI?
	
	@IBOutlet fileprivate var tableView: NSTableView!
	fileprivate var features: [(String, String)]?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tableView.delegate = self
		tableView.dataSource = self
	}
}

extension FeaturesViewController: NSTableViewDataSource {
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		
		return features?.count ?? 0
	}
}

extension FeaturesViewController: NSTableViewDelegate {
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		
		guard let features = features else {
			return nil
		}
		
		var id: String
		var text: String
		if tableColumn == tableView.tableColumns[0] {
			id = "KeyID"
			text = features[row].0
		} else {
			id = "ValueID"
			text = features[row].1
		}
		
		if let cell = tableView.make(withIdentifier: id, owner: nil) as? NSTableCellView {
			cell.textField?.stringValue = text
			return cell
		}
		
		return nil
	}
}

extension FeaturesViewController: SongChangeDelegate {
	
	func songDidChange(_ song: Song) {
		
		api?.features(forSong: song) { features in
			
			guard let features = features else {
				return
			}
			
			self.features = features.formattedValues()
			self.tableView.reloadData()
		}
	}
}
