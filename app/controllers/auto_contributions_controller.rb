class AutoContributionsController < ApplicationController
  def create
  end

  def new
    @client = Octokit::Client.new(access_token: User.first.oauth_token)
    all_repos = @client.org_repos('zense')
    @users_contributed_repos = Array.new

    i = all_repos.count - 1
    while i >= 0 do
      contributors = @client.contribs(all_repos[i].full_name)
      puts all_repos[i].full_name
      j = contributors.count - 1
      while j >= 0 do
        if contributors[j].login == current_user.name
          @users_contributed_repos.push(all_repos[i].name)
        end
        j -= 1
      end
      i -= 1
    end


  end

  def index
  end
end
