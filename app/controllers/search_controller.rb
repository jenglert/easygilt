class SearchController < ApplicationController
  def index
    @query = params[:query]

    if !@query.nil?  && @query != '' && @query != 'SEARCH HERE'
      @results = do_search(@query)
    end
  end

  def results_ajax
    @query = params[:query]

    @results = []
    if !@query.nil?  && @query != '' && @query != 'SEARCH HERE'
      @results = do_search(@query)
    end

    render :layout => 'blank'
  end

  def do_search(query)
    words = ApiFetcher.clean_phrase(query)
    words = words.map { |word| "'" + word + "'" }

    results = ActiveRecord::Base.connection.select_all("select product_id as product_id from search_terms where term in (#{words.join(', ')}) group by product_id order by sum(\"percentage\") desc limit 50")

    product_ids = results.map { |result| result['product_id'] }

    Product.find(:all, :conditions => ["id in (?)", product_ids], :limit => 50, :include => [:product_images, {:product_skus => :product_sku_attributes }])
  end


  def single_item_style
    @product = Product.first
  end

end

