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
  redirect '/index_test.html'
end

get '/calculate' do
  params[:iturl]

	agent = Mechanize.new # содержит инфу о куки, сессиях и др.
	page = agent.get 'https://it.bonasource.com/'# первый раз обращаемся чтобы получить куки
	page = agent.get 'https://it.bonasource.com/IssueListSimple.asp?projectid=114&sp3=-2&sp20=sp5&sp21=0&username=read_only_user&pass=w1ldb0na$'

	puts "item " + page.parser.xpath('//table/tr').count.to_s

	statuses = {}
	statuses["To Do"] = 0
	statuses['To CodeReview'] = 0
	statuses['Ready to dev'] = 0
	statuses['Postponed'] = 0
	statuses['To Estimate'] = 0
	statuses['To Test'] = 0
	statuses['To Accept'] = 0
	statuses['Analysis'] = 0
	statuses['Design'] = 0
	statuses['Done'] = 0
	statuses['To Publish'] = 0
	statuses['Archived'] = 0

	page.parser.xpath('//table/tr/td[5]').each do |td| 
		statuses[td.content] = statuses[td.content]+1
	end
	statuses.to_json

end
