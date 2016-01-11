module ApplicationHelper

	# To run locally, set URL here.
	# For example, URL = "mongodb://localhost:27017/test"	
	URL = ""
	
	def runHelloWorld()

		output = Array.new
		
		if (URL == nil || URL == "") 
			logger.info("parsing VCAP_SERVICES")
			if ENV['VCAP_SERVICES'] == nil
				output.push("vcap services is nil")
				return output
			end
                        serviceName = "timeseriesdatabase"
			if ENV['SERVICE_NAME'] != nil
				serviceName = ENV['SERVICE_NAME']
			end
			logger.info("Using service name " + serviceName)
			vcap_hash = JSON.parse(ENV['VCAP_SERVICES'])[serviceName]
			credHash = vcap_hash.first["credentials"]
			USE_SSL = false
			if (USE_SSL)
				mongodb_url = credHash["mongodb_url_ssl"]
			else
				mongodb_url = credHash["mongodb_url"]
			end
			logger.info("Using mongodb_url " + mongodb_url)
		else
			mongodb_url = URL
		end

		output.push("Starting test...")
		
		begin
			output.push("Connecting to " + mongodb_url)
			mongo_client = Mongo::Client.new(mongodb_url)
			db = mongo_client.database

			collectionName = "rubyMongo"
			output.push("Creating collection 'rubyMongo' in database")
			output.push(" ")
			mongo_client[collectionName].drop # make sure it does not already exist
			collection = mongo_client[collectionName]  
			collection.create
	
			output.push("Insert a single document to a collection") 
			collection.insert_one({ :name => "test1", :value => 1})
			output.push("Inserted {\"name\": \"test1\", \"value\": 1}" )  
			output.push(" ")
	
			output.push("Inserting multiple entries into collection")
			multiPost = [{:name => "test1", :value => 11},{:name => "test2", :value => 2}, {:name => "test3", :value => 3}] 
			collection.insert_many(multiPost)
			output.push("Inserted {name: \"test1\", value: 1} {name: \"test2\", value: 2} {name: \"test3\", value: 3}")
			output.push(" ")
	
			output.push("Find one that matches a query condition")
			item = collection.find({name: "test1"}).limit(1)
			output.push(item.to_json)
			output.push(" ")
	
			output.push("Find all that match a query condition")
			collection.find(:name => "test1").each do |document|
				output.push(document.to_json)
			end
			output.push(" ")
	
			output.push("Find all documents in collection")
			collection.find().each do |document|
				output.push(document.to_json)
			end
			output.push(" ")

			output.push("Updating entry with attribute")
			collection.find(:name => "test3").update_many("$set" => { :value => 4})
			output.push("Updated test3 with value 4")
			output.push(" ")
	
			output.push("Delete all with attribute")
			collection.find(:name => "test2").delete_many 
			output.push("Deleted all with name test2")
			output.push(" ")
	
			output.push("Drop a collection")
			collection.drop
	
			output.push(" ")
			output.push("Test Finished")
		ensure
			if (mongo_client != nil) 
				mongo_client.close
			end	
		end	

		return output
	end
end
