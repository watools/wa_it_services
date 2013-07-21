require 'sinatra'
require 'mechanize'
require 'json'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
I_KNOW_THAT_OPENSSL_VERIFY_PEER_EQUALS_VERIFY_NONE_IS_WRONG = nil

set :public_folder, 'public'

get '/' do
  redirect '/index.html'
end

get '/test' do
  redirect '/index-test.html'
end

get '/calculate' do
	agent = Mechanize.new # содержит инфу о куки, сессиях и др.
	page = agent.get 'https://it.bonasource.com/'# первый раз обращаемся чтобы получить куки
	page = agent.get params[:iturl]

	statuses = {}

	page.parser.xpath('//table/tr/td[5]').each do |td| 
	  statuses[td.content] = 0 if statuses[td.content] == nil
	  statuses[td.content] = statuses[td.content] + 1
	end
	statuses.to_json
end

get '/extract' do
  	agent = Mechanize.new # содержит инфу о куки, сессиях и др.
	page = agent.get 'https://it.bonasource.com/'# первый раз обращаемся чтобы получить куки
	page = agent.get params[:iturl]

	c_names = params[:columnNames].split(':')

	column_names = {}

	
	# get mapping between column name and and its number
	page.parser.xpath('//table//th').each_with_index do |th, index|
	column_names[th.content] = index if c_names.include?(th.content)

	end
	puts column_names

        all_issues_fields = {}
	page.parser.xpath('//table//tr').drop(1).each do |tr| 
	  issue_fields = []
	 
          tds = tr.xpath('td')
	  
          #puts tds
	  column_names.values.each do |column_index|
	    issue_fields.push tds[column_index].content  
	  end
 	  
	  issue_ID = tds[1].content
	  all_issues_fields[issue_ID] = issue_fields
	end
	
	result = {}
	result["columns names"] = c_names
	result["issues fields values"] = all_issues_fields
	
	result.to_json
	
end
