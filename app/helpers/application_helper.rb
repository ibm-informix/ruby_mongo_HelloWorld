module ApplicationHelper
	
	def runHelloWorld()

		outPut = Array.new
		
		if ENV['VCAP_SERVICES'] == nil
			outPut.push("vcap services is nil")
			return outPut
		end
		vcap_hash = JSON.parse(ENV['VCAP_SERVICES'])["altadb-dev"]
		credHash = vcap_hash.first["credentials"]
		host = credHash["host"]
		port = credHash["json_port"]
		jsonUrl = credHash["json_url"]
		dbname= credHash['db']
		user = credHash["username"]
		password = credHash["password"]
		collectionName = "mongoCollection"
		outPut.push("Before connection")
		
		mongo_client = Mongo::Client.new(["#{host}:#{port}"])
		db = mongo_client.database

		collectionName = "rubyMongo"
		outPut.push("Creating collection 'rubyMongo' in admin database")
		outPut.push(" ")
		#mongo_client[collectionName].drop # make sure it does not already exist
		#collection = mongo_client[collectionName]  giving error undefined method `downcase' for {:host=>"27017"}:Hash):
		# therefore using collection initialization method
		#collection = Mongo::Collection.new(db, collectionName) giving error ActionView::Template::Error (undefined method `command' for "s1662732":String):
		collection.create
=begin
		outPut.push("Insert a single document to a collection") 
		collection.insert_one({ :name => "test1", :value => 1})
		outPut.push("Inserted {\"name\": \"test1\", \"value\": 1}" )  
		outPut.push(" ")

		outPut.push("Inserting multiple entries into collection")
		multiPost = [{:name => "test1", :value => 1},{:name => "test2", :value => 2}, {:name => "test3", :value => 3}] 
		collection.insert_many(multiPost)
		outPut.push("Inserted {name: \"test1\", value: 1} {name: \"test2\", value: 2} {name: \"test3\", value: 3}")

		outPut.push("Find one that matches a query condition")
		item = collection.find({name: "test1"}).limit(1)
		outPut.push(item.to_json)
		outPut.push(" ")

		outPut.push("Find all that match a query condition")
		# First input another entry for test1 so that there are multiple docs with same name
		collection.insert_one({:name => "test1", :value => 10})
		collection.find(:name => "test1").each do |document|
			outPut.push(document.to_json)
		end
		outPut.push(" ")

		outPut.push("Find all documents in collection")
		collection.find().each do |document|
			outPut.push(document.to_json)
		end

		outPut.push("Updating entry with attribute")
		collection.find(:name => "test3").update_many("$set" => { :value => 4})
		outPut.push("Updated test3 with value 4")
		outPut.push(" ")

		outPut.push("Delete all with attribute")
		collection.find(:name => "test2").delete_many 
		outPut.push("Deleted all with name test2")
		outPut.push(" ")

		outPut.push("Get a list of all of the collections")
		outPut.push(db.collection_names)
		
		outPut.push("Drop a collection")
		collection.drop

		db.drop
		outPut.push(" ")
		outPut.push("Test Finished")
=end
		return outPut
	end
end
