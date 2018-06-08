class FetchContributionsJob
  include Sidekiq::Worker
  def perform()
    Sidekiq::ScheduledSet.new.clear
    Fetch.perform_in(1.days)
    FetchGithubContribution.new.get_github_contributions
  end
end

FetchContributionsJob.perform_in(1.days)



