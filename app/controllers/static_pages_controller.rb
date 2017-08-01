class StaticPagesController < ApplicationController
  layout :resolve_layout
  skip_before_action :authenticate_user!

  def home
  end

  def terms
  end

  def anti_spam

  end

  def changelog
    @subnav = 'changelog'
    $git_client = Octokit::Client.new(access_token: ENV['GITHUB_PERSONAL'])

    @commits = $git_client.commits('ColinW520/hydra', 'master', since: 1.month.ago ).map(&:commit)
    @issues = $git_client.issues('ColinW520/hydra', state: 'open')
  end

  protected
    def resolve_layout
      return 'static_views' unless action_name == 'changelog'
      return 'application'
    end
end
