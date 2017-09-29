class FeedItems::CreatorWorker
  include Sidekiq::Worker

  def perform(details)
    FeedItem.create(details)
  end
end

# we do this Async so that the user experience isn't interrupted or hinging on feed item creation.
# details should look like this:
# { organization_id: 17, user_id: 348, parent_type: 'Thing', parent_id: 128, phrase: 'Sent a message to 1872 recipients'}
