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
    json_document = ""
    file = File.new(api_file_location, "r")
    while (line = file.gets)
      json_document += line
    end
    file.close

    json = JSON.parse(json_document)

    json.each do |sale|
      products = sale['products']
      next if products.nil?
      products.each do |product|
        skus = product['skus']
        brand = product['brand']
        name = product['name']
        url = product['url']
        image_urls = product['image_urls']

        content_hash = product['content']
        description = content_hash['description']
        fit_notes = content_hash['fit_notes']
        material = content_hash['material']
        origin = content_hash['origin']

        product = Product.create!(:name => name, :url => url, :brand => brand, :description => description, :fit_notes => fit_notes, :material => material, :origin => origin)

        image_urls.each do |image_url|
          ProductImage.create(:product_id => product.id, :image_url => image_url)
        end

        skus.each do |sku|
          msrp_price = sku['msrp_price']
          sale_price = sku['sale_price']
          attributes = sku['attributes']

          product_sku = ProductSku.create!(:product_id => product.id, :msrp_price => msrp_price, :sale_price => sale_price)

          next if attributes.nil?
          attributes.each do |attribute|
            attribute_name = attribute['name']
            attribute_value = attribute['value']
            ProductSkuAttribute.create(:product_sku_id => product_sku.id, :name => attribute_name, :value => attribute_value)
          end

        end
      end
    end

    true
  end

end