class StaticPagesController < ApplicationController
  layout :resolve_layout
  skip_before_action :authenticate_user!

  def home
  end

  def terms
  end

  def anti_spam
  end

  def privacy
  end

  def contact
    respond_to do |format|
      format.js do
        if params[:spam_check] != 'gotcha.'
          flash[:alert] = 'We think this might be spam...'
        else
          ContactMailer.contact_message(params[:name], params[:email], params[:message]).deliver
          flash[:success] = 'Your message was sent! We will get back to you shortly.'
        end
      end
    end
  end

  def changelog
    @subnav = 'changelog'
    client = Octokit::Client.new(username: ENV['GITHUB_USERNAME'], password: ENV['GITHUB_PASSWORD'])

    @commits = client.commits('ColinW520/hydra', 'master', since: 1.month.ago ).map(&:commit)
    @issues = client.issues('ColinW520/hydra', state: 'open')
  end

  protected
    def resolve_layout
      return 'static_views' unless action_name == 'changelog'
      return 'application'
    end
end
