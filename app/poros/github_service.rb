require 'httparty'
require './config/application'

class GitHubService
  def repo_information
    get_url('https://api.github.com/repos/eport01/little-esty-shop')
  end

  def pr_information 
    get_url('https://api.github.com/repos/eport01/little-esty-shop/pulls?state=closed')
  end

  def commits_information
    get_url("https://api.github.com/repos/eport01/little-esty-shop/commits?per_page=100")
  end

  def get_url(url)
    response = HTTParty.get(url, headers: { 'Authorization' => "Bearer #{ENV['GITHUB_API_KEY']}" })
    parsed = JSON.parse(response.body, symbolize_names: true)
  end
end

