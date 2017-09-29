class FeedItemsController < ApplicationController
  def index
    feed_items_scope = current_user.organization.feed_items

    respond_to do |format|
      format.html { smart_listing_create :feed_items, feed_items_scope, partial: 'feed_items/listing', default_sort: { created_at: 'DESC' }, page_sizes: [100, 150, 200] }
      format.js { smart_listing_create :feed_items, feed_items_scope, partial: 'feed_items/listing', default_sort: { created_at: 'DESC' }, page_sizes: [100, 150, 200] }
      format.csv { send_data feed_items_scope.to_csv, filename: "feed_items_as_of-#{Time.now}.csv" }
    end
  end
end
