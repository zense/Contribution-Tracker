require 'sidekiq/api'
 
class FetchContributionsWorker
  include Sidekiq::Worker
  def perform()
    Sidekiq::ScheduledSet.new.clear
    FetchContributionsWorker.perform_in(1.days)
    FetchGithubContribution.new.get_github_contributions
  end
end

#FetchContributionsWorker.perform_in(10.seconds)



