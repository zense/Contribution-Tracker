require './app/models/fetch_contribution.rb'

class FetchContributionsJob < ApplicationJob
  queue_as :default
  after_perform do |job|
    self.class.set(wait: 1.days).perform_later(job.arguments.first)
  end

  def perform(*args)
    a = FetchGithubContribution.new
    a.get_github_contributions
  end
end
