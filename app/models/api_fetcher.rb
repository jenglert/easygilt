require 'net/http'
require 'json'

class ApiFetcher

  API_KEY = "2a79c53507fe657d88a685380bf46021"

  def ApiFetcher.fetch_api_file
    site = "api.gilt.com"
    url_path = "/v1/sales/active.json?apikey=#{API_KEY}&product_detail=true"
    file_name = "./api_downloads/sales_feed_#{Time.now.to_s}.api_download.json"

    http = Net::HTTP.new(site,443)
    http.use_ssl = true

    http.start { |http_connec|
      resp = http_connec.get(url_path)
      open(file_name, "wb") { |file|
        file.write(resp.body)
       }
    }

    file_name
  end

  def ApiFetcher.parse_api_file(api_file_location)

  end

end