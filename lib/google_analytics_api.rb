require 'rest_client'

##
# Google Analytics API class
# - Source: http://goo.gl/BXcbij
class GoogleAnalyticsApi
  ##
  # Tracks an event
  # - category: main grouping of an event
  # - action: specific action taken
  # - client_id: the Google Analytics-generated unique identifier
  def event(category, action, client_id = '555')
    return if ENV['GOOGLE_ANALYTICS_ID'].blank?
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

  ##
  # Sends the event to Google Analytics
  def send_event(params = {})
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
