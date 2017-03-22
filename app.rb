# encoding: utf-8

require 'sinatra'
require 'mongolitedb'
require 'json'
require './config/database'
require './config/cipher'

configure do
    set :public_folder, 'public'
    set :views, 'views'
    set :server, :puma
end

get '/' do
	db = Database.new
	rs = db.connection().find({})
	rs.to_json
end

get '/generar' do
	  rpta = ''
     usuario = params[:usuario]

     begin
         	o = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten
			string = (0...25).map { o[rand(o.length)] }.join
			token = AesEncryptDecrypt.encryption(string)
			doc = {'usuario' => usuario, 'token' => token}

			db = Database.new
			db.connection().insert(doc)
			rpta = { :tipo_mensaje => 'success', :mensaje => ['token', token] }.to_json
     rescue StandardError => e #ZeroDivisionError
         	rpta = { :tipo_mensaje => 'error', :mensaje => ['Se ha producido un error al generar el token al usuario', e] }.to_json
     end
         
    rpta 
end

get '/get_token' do
	rpta = ''
   usuario = params[:usuario]

   begin
		db = Database.new
		rs = db.connection().find({'usuario' => usuario})

		if rs.length == 1
			doc = rs[0]
			rpta = { :tipo_mensaje => 'success', :mensaje => [doc['token']] }.to_json
		else
			rpta = { :tipo_mensaje => 'warning', :mensaje => ['usuario no encontrado'] }.to_json
		end
	rescue StandardError => e #ZeroDivisionError
      	rpta = { :tipo_mensaje => 'error', :mensaje => ['Se ha producido un error al obtener el token al usuario', e] }.to_json
   end
         
    rpta 
end

get '/borrar' do
	rpta = ''
	usuario = params[:usuario]

	 begin
			db = Database.new
			db.connection().delete({'usuario' => usuario})
			rpta = { :tipo_mensaje => 'success', :mensaje => 'usuario eliminado' }.to_json
     rescue StandardError => e #ZeroDivisionError
         	rpta = { :tipo_mensaje => 'error', :mensaje => ['Se ha producido un error al eleminar el token del usuario', e] }.to_json
     end
   
    rpta 
end