#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	return SQLite3::Database.new 'barbershop.db'
end

# Initial database
configure do

	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS
				"Users"
				(
					"id" INTEGER PRIMARY KEY AUTOINCREMENT,
					"user_name" TEXT,
					"user_phone" TEXT,
					"date_stamp" TEXT,
					"barber" TEXT,
					"color" TEXT
					)'
end

get '/' do
	erb "Hello!"
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@user_name = params[:user_name]
	@user_phone = params[:user_phone]
	@date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:user_color]

	# Validation
	hh = { :user_name => "Введите имя",
				 :user_phone => "Введите номер телефона",
			 	 :date_time => "Введите дату и время" }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'insert into Users (user_name, user_phone, date_stamp, barber, color)
							values (?, ?, ?, ?, ?)', [@user_name, @user_phone, @date_time, @barber, @color]

	@title = "Thank you!"
	@message = "Dear #{@user_name}, we'll be waiting for you at #{@date_time}. #{@color}."

	erb :message
end

get '/contacts' do
	erb :contacts
end

post '/contacts' do
	erb :contacts
end

get '/about' do
	erb :about
end

get '/showusers' do
	erb :showusers
end
