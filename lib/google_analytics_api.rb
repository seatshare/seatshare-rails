require 'rest_client'

# https://deveo.com/blog/2013/05/07/server-side-google-analytics-event-tracking-with-rails/
class GoogleAnalyticsApi
  def event(category, action, client_id = '555')
    return unless ENV['GOOGLE_ANALYTICS_ID'].present?
    params = {
      v: 1,
      tid: ENV['GOOGLE_ANALYTICS_ID'],
      cid: client_id,
      t: 'event',
      ec: category,
      ea: action
    }
    send_event params
  end

  private

  def send_event
    RestClient.get(
      'http://www.google-analytics.com/collect',
      params: params,
      timeout: 4,
      open_timeout: 4
    )
    return true
  rescue RestClient::Exception
    return false
  end
end
