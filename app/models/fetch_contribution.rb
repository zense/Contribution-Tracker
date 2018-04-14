require 'net/http'

$time = "2018-01-01T00:00:00"
class FetchGithubContribution
  def get_github_contributions
    #run everything twice
    #read https://developer.github.com/v3/repos/statistics/#a-word-about-caching
    self.latest_repos
    self.get_all_contributors
    self.get_number_of_pr
    self.get_number_of_commits
    self.get_number_of_issues

    self.latest_repos
    self.get_all_contributors
    self.get_number_of_pr
    self.get_number_of_commits
    self.get_number_of_issues
    self.calulate_individual_stats_and_delete_invalid_contributions
    self.user_total_stats
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
    all_repos = self.fetch_all_repos
    i = all_repos.count
    while i > 0
      repo = all_repos[i - 1]["name"]
      url = "https://api.github.com/repos/zense/#{repo}/commits?since=#{$time}&access_token=#{User.first.oauth_token}"
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
          contribution = Contribution.create(name: repo, contribution_type: "Github Project", status: "Approved", user: user)
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
    while i>0
      user = User.find(all_contribution[i-1].user_id).name
      if(user)
        repo = all_contribution[i-1].name
        url = "https://api.github.com/repos/zense/#{repo}/commits?author=#{user}&since=#{$time}&access_token=#{User.first.oauth_token}"
        user_commits = parse_json(url)
        number_of_commits = user_commits.count
        contribution = all_contribution[i-1]
        contribution.commits = number_of_commits
        
        #TODO
        #TODO generalize for other empty repos
        #for repos like new_projects
        if repo == "new_projects"
          contribution.commits = 0
        end
        contribution.save
      end
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
        if(user)
          if(user == query_user)
            return true
          end
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
        user = User.find_by name: issue_author
        if(user)
          user_id = user.id
          if(check_contributor(issue_author,repo))
            contribution = Contribution.find_by name: repo, user_id:user_id
            contribution.issues += 1
          else
            Contribution.create(name: repo, contribution_type: "Github Project", status: "Approved", user_id: user_id, issues: 1)
          end
        end
         j-=1
      end
      i-=1
    end
  end

  def get_number_of_pr
    all_contribution = Contribution.where contribution_type: "Github Project"
    i = all_contribution.count
    while i > 0
      contribution = all_contribution[i-1]
      user = User.find(contribution.user_id).name
      if(user)
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
      end
       i-=1
    end
  end

  def calulate_individual_stats_and_delete_invalid_contributions
    all_contribution = Contribution.where contribution_type: "Github Project"
    i = all_contribution.count
    while i > 0
      contribution = all_contribution[i-1]
      contribution.total = contribution.commits + contribution.pull_requests + contribution.issues
      if(contribution.total == 0)
        Contribution.delete(contribution)
      else
        contribution.save
      end
      i -= 1
    end
  end

  def user_total_stats
    all_users = User.all
    i = all_users.count
    while i > 0
      user = all_users[i-1]
      user.issues = 0
      user.commits = 0
      user.pull_requests = 0
      user.total = 0
      all_contributions = user.contributions
      j = all_contributions.count
      while j > 0
        user.issues += all_contributions[j-1].issues
        user.commits += all_contributions[j-1].commits
        user.pull_requests += all_contributions[j-1].pull_requests
        user.total += all_contributions[j-1].total
        user.save
        j-=1
      end
       i-=1
    end
  end
end

