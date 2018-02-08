require 'net/http'

module FetchGithubContributions
  def get_github_contributions
    latest_repos
    get_all_contributors
    get_number_of_pr
    get_number_of_commits
    get_number_of_issues

  end

  def parse_json(url)
    uri = URI(url)
    response = Net::HTTP.get(uri)
    if(response)
      return JSON.parse(response)
    else
      return nil
    end
  end

  #get all repos after a specific date and save it to the database
  def latest_repos
    latest_repos = []
    all_repos = fetch_all_repos
    i = all_repos.count
    while i > 0
      time = "2018-01-01T00:00:00"
      repo = all_repos[i - 1]["name"]
      url = "https://api.github.com/repos/zense/#{repo}/commits?since=#{time}&access_token=#{User.first.oauth_token}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
      
      if(response != "[]")
        #idk why but instead of returning json the url is returning the json wrapped inside []
        response = response[1..-2]


        commits = JSON.parse(response.to_json)

        if(commits)
          Repo.create(name: repo)
        end
      end
      i -= 1
    end
  end
    
  

  #get all zense repos
  def fetch_all_repos
    access_token = User.first.oauth_token
    url = "https://api.github.com/orgs/zense/repos?access_token=#{access_token}"
    all_repos = parse_json(url)
    return all_repos
  end

  
  #get contributors for a single repo and save em as a contribution
  def get_contributors(repo)
    url = "https://api.github.com/repos/zense/#{repo}/stats/contributors?access_token=#{User.first.oauth_token}"
    repo_info = parse_json(url)

    if(repo_info)
      n = repo_info.count
      while n > 0
        user = User.find_by name: repo_info[n-1]["author"]["login"]
        if(user)
          contribution = Contribution.create(name: repo, contribution_type: "Github Project", status: "Pending", user: user)
        end
        n -= 1
      end
    end
  end

  #get all contributions
  def get_all_contributors
    all_repos = Repo.all
    i = all_repos.count
    while i > 0
      get_contributors(all_repos[i-1]["name"])
      i -= 1
    end
  end

  #for all contributions
  def get_number_of_commits
    all_contribution = Contribution.where contribution_type: "Github Project"
    i = all_contribution.count
    time = "2018-01-01T00:00:00"
    while i>0
      user = User.find(all_contribution[i-1].user_id).name
      repo = all_contribution[i-1].name
      url = "https://api.github.com/repos/zense/#{repo}/commits?author=#{user}&since=#{time}&access_token=#{User.first.oauth_token}"
      user_commits = parse_json(url)
      number_of_commits = user_commits.count
      contribution = all_contribution[i-1]
      contribution.commits = number_of_commits
      contribution.save
       i -= 1
    end
  end

  #check is a user is a contributor to a repo
  def check_contributor(query_user,repo)
    url = "https://api.github.com/repos/zense/#{repo}/stats/contributors?access_token=#{User.first.oauth_token}"
    contributors = parse_json(url)
    if(contributors)
      n = contributors.count

      while n > 0
        user = User.find_by name: contributors[n-1]["author"]["login"]
        if(user == query_user)
          return true
        end
         n-=1
      end

      return false
    end
  end

        

  def get_number_of_issues
    all_repos = Repo.all
    i = all_repos.count
    while i > 0
      repo = all_repos[i-1].name
      url = "https://api.github.com/repos/zense/#{repo}/issues?access_token=#{User.first.oauth_token}"
      repo_issues = parse_json(url)
      j = repo_issues.count

      while j > 0

        issue_author = repo_issues[j-1]["user"]["login"]
        user_id = (User.find_by name: issue_author).id
        if(check_contributor(issue_author,repo))
          contribution = Contribution.find_by name: repo, user_id:user_id
          contribution.issues += 1
        else
          Contribution.create(name: repo, contribution_type: "Github Project", status: "Pending", user_id: user_id, issues: 1)
        end
         j-=1
      end

      i-=1
    end
  end

  def get_number_of_pr
    all_contribution = Contribution.where contribution_type: "Github Project"
    i = all_contribution.count
    time = "2018-01-01T00:00:00"
    while i > 0
      contribution = all_contribution[i-1]
      user = User.find(contribution.user_id).name
      repo = contribution.name
      url = "https://api.github.com/repos/zense/#{repo}/pulls?state=all&access_token=#{User.first.oauth_token}"
      repo_prs = parse_json(url)
      j = repo_prs.count
      count = 0
      while j > 0
        if(repo_prs[j-1]["user"]["login"] == user)
          count += 1
        end

        j -= 1
      end

      contribution.pull_requests = count
      contribution.save
       i-=1
    end
  end

end

