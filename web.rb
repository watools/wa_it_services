require 'sinatra'

get '/' do
  File.read(File.join('public', 'view/index.html'))
end
