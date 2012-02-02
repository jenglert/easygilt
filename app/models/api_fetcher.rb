require 'net/http'
require 'json'

class ApiFetcher

  API_KEY = "2a79c53507fe657d88a685380bf46021"

  STORES = ['men', 'women', 'home', 'kids']

  STOP_WORDS = [ "a", "about", "above", "above", "across", "after", "afterwards", "again", "against", "all", "almost", "alone", "along", "already", "also","although","always","am","among", "amongst", "amoungst", "amount",  "an", "and", "another", "any","anyhow","anyone","anything","anyway", "anywhere", "are", "around", "as",  "at", "back","be","became", "because","become","becomes", "becoming", "been", "before", "beforehand", "behind", "being", "below", "beside", "besides", "between", "beyond", "bill", "both", "bottom","but", "by", "call", "can", "cannot", "cant", "co", "con", "could", "couldnt", "cry", "de", "describe", "detail", "do", "done", "down", "due", "during", "each", "eg", "eight", "either", "eleven","else", "elsewhere", "empty", "enough", "etc", "even", "ever", "every", "everyone", "everything", "everywhere", "except", "few", "fifteen", "fify", "fill", "find", "fire", "first", "five", "for", "former", "formerly", "forty", "found", "four", "from", "front", "full", "further", "get", "give", "go", "had", "has", "hasnt", "have", "he", "hence", "her", "here", "hereafter", "hereby", "herein", "hereupon", "hers", "herself", "him", "himself", "his", "how", "however", "hundred", "ie", "if", "in", "inc", "indeed", "interest", "into", "is", "it", "its", "itself", "keep", "last", "latter", "latterly", "least", "less", "ltd", "made", "many", "may", "me", "meanwhile", "might", "mill", "mine", "more", "moreover", "most", "mostly", "move", "much", "must", "my", "myself", "name", "namely", "neither", "never", "nevertheless", "next", "nine", "no", "nobody", "none", "noone", "nor", "not", "nothing", "now", "nowhere", "of", "off", "often", "on", "once", "one", "only", "onto", "or", "other", "others", "otherwise", "our", "ours", "ourselves", "out", "over", "own","part", "per", "perhaps", "please", "put", "rather", "re", "same", "see", "seem", "seemed", "seeming", "seems", "serious", "several", "she", "should", "show", "side", "since", "sincere", "six", "sixty", "so", "some", "somehow", "someone", "something", "sometime", "sometimes", "somewhere", "still", "such", "system", "take", "ten", "than", "that", "the", "their", "them", "themselves", "then", "thence", "there", "thereafter", "thereby", "therefore", "therein", "thereupon", "these", "they", "thickv", "thin", "third", "this", "those", "though", "three", "through", "throughout", "thru", "thus", "to", "together", "too", "top", "toward", "towards", "twelve", "twenty", "two", "un", "under", "until", "up", "upon", "us", "very", "via", "was", "we", "well", "were", "what", "whatever", "when", "whence", "whenever", "where", "whereafter", "whereas", "whereby", "wherein", "whereupon", "wherever", "whether", "which", "while", "whither", "who", "whoever", "whole", "whom", "whose", "why", "will", "with", "within", "without", "would", "yet", "you", "your", "yours", "yourself", "yourselves", "the"]

  def ApiFetcher.clear_products(store)
    product.find_in_batches(:conditions => ["store = ?", store]) do |group|
        group.each do |product|
          product.destroy
        end
      end
  end

  def ApiFetcher.reload_products(store)

    Product.find_in_batches(:conditions => ["store = ?", store]) do |products|
       products.each do |product|
         keys = {}
         ApiFetcher.count_words(product.name, keys, 4)
         ApiFetcher.count_words(product.description, keys)
         ApiFetcher.count_words(product.material, keys)
         ApiFetcher.count_words(product.origin, keys)
         ApiFetcher.count_words(product.brand, keys)
         product.product_skus.each do |product_sku|
           product_sku.product_sku_attributes.each do |product_sku_attribute|
             ApiFetcher.count_words(product_sku_attribute.value, keys)
            end
         end

         keys.each do |word, count|
           SearchTerm.create!(:product_id => product.id, :term => word, :count => count)
         end
       end
     end
  end

  def ApiFetcher.clean_phrase(phrase)
    return [] if phrase.nil?

    words = []

    phrase.split.each do |word|
      word = word.downcase.gsub(/[^a-z]/, "")

      next if word == ''
      next if STOP_WORDS.include?(word)
      next if word.size < 3

      words << word
    end
  end

  def ApiFetcher.count_words(phrase, keys, multiplier = 1)
    words = ApiFetcher.clean_phrase(phrase)
    words.each do |word|
      keys[word] ||= 0
      keys[word] = keys[word] + multiplier
    end
  end

  def ApiFetcher.job_get_files
    STORES.each do |store|
      file = ApiFetcher.fetch_api_file(store)
      ApiFetcher.parse_api_file(file, store)
      ApiFetcher.clear_products(store)
    end
  end

  def ApiFetcher.fetch_api_file(store)
    site = "api.gilt.com"
    url_path = "/v1/sales/#{store}/active.json?apikey=#{API_KEY}&product_detail=true"
    file_name = "./api_downloads/sales_feed_#{Time.now.to_s}.api_download.json"

    http = Net::HTTP.new(site,443)
    http.use_ssl = true

    http.start { |http_connec|
      puts "downloading from: https://#{site}/#{url_path}"
      resp = http_connec.get(url_path)
      open(file_name, "wb") { |file|
        file.write(resp.body)
       }
    }

    file_name
  end

  def ApiFetcher.parse_api_file(api_file_location, store)
    json_document = ""
    file = File.new(api_file_location, "r")
    while (line = file.gets)
      json_document += line
    end
    file.close

    json = JSON.parse(json_document)

    json['sales'].each do |sale|
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

        product = Product.create!(:name => name, :url => url, :brand => brand, :description => description, :fit_notes => fit_notes, :material => material, :origin => origin, :store => store)

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