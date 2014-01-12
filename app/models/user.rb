class User < ActiveRecord::Base
  serialize :hometown
  serialize :location

  before_save :update_facebook_data

  validate :fetch_facebook_data
  validates_uniqueness_of :username

  private

  def generate_graph_api_url
    "https://graph.facebook.com/me?access_token=#{access_token}" +
      "&fields=id,username,name,gender,hometown,location,bio"
  end

  def fetch_facebook_data
    require 'net/http'

    uri = URI.parse(generate_graph_api_url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(uri.request_uri)

    res = http.request(request)

    response = JSON.parse(res.body)

    errors.add(:access_token, 'is invalid.') if response['error'].present?
    response
  end

  def update_facebook_data
    data = fetch_facebook_data
    self.assign_attributes({
                             fid: data['id'],
                             username: data['username'],
                             name: data['name'],
                             gender: data['gender'],
                             hometown: data['hometown'],
                             location: data['location'],
                             bio: data['bio']
                           })
  end
end
