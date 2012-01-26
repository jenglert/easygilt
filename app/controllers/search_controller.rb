class SearchController < ApplicationController
  def index
    @query = params[:query]

    if !@query.nil?  && @query != ''
      @results = do_search(@query)
    end
  end

  def do_search(query)
    Product.find(:all, :conditions => [
        "to_tsvector('english', description) @@ to_tsquery('english', ?)",
        query
      ])
  end


  def single_item_style
    @product = Product.first
  end

end

