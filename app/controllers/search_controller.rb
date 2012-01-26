class SearchController < ApplicationController
  def index
    @query = params[:query]

    unless @query == ''
      @results = do_search(@query)
    end
  end

  def do_search(query)
    Product.find(:all, :conditions => [
      "lower(name) like ? or lower(description) like ?",
      "%#{query}%",
      "%#{query}%"
      ])
  end
end
