# config/database.rb

require 'mongolitedb'

class Database
	def initialize
		file_name = 'db/db_tokens.mglite' 
		@connection = MongoLiteDB.new file_name
	end

	def connection
		@connection
	end
end