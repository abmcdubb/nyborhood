require 'cgi'
class SmartyStreetApi

  Building.limit(100).map |address|
    address = [
    {"street"=> address,
     "city"=> "New York City",
     "state"=> "NY",
     "zipcode"=> zip,
     "candidates"=> 10
    }]


  auth_token = ENV['AUTH_TOKEN']
  auth_id = ENV['AUTH_ID']

  conn = Faraday.new(:url => 'https://api.smartystreets.com') do |faraday|
    faraday.request  :url_encoded             # form-encode POST params
    faraday.response :logger                  # log requests to STDOUT
    faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
  end

  response = conn.post do |req|
    req.url '/streetaddress'
    req.params['auth-id'] = auth_id
    req.params['auth-token'] = auth_token
    req.headers['Content-Type'] = 'application/json'
    req.body = address.to_json
  end

  puts JSON.pretty_generate(JSON.parse(response.body))
  end