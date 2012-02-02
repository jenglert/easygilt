class HotController < ApplicationController
  def index
    num = Product.count
    @product1 = Product.find(:first, :offset => (rand * num).to_i)
    while @product2.nil? or @product2.id == @product1.id
      @product2 = Product.find(:first, :offset => (rand * num).to_i)
    end

    if request.post?
      winner = Product.find(params[:winner])
      loser = Product.find(params[:loser])
      unless winner.nil? and loser.nil?
        winner.product_hot_votes.create(:is_winner => true)
        loser.product_hot_votes.create(:is_winner => false)
      end
    end
  end

  def top
    @title = "Hottest products"
    limit = params[:limit].to_i
    limit = 10 if limit <= 0
    @products = Product.find_by_sql("select products.* from products join (select product_id, sum(case when is_winner then 1 else -1 end) as score from product_hot_votes group by product_id) as votes on products.id = votes.product_id and votes.score > 0 order by votes.score desc limit #{limit}")
    render :list
  end

  def bottom
    @title = "Coldest products"
    limit = params[:limit].to_i
    limit = 10 if limit <= 0
    @products = Product.find_by_sql("select products.* from products join (select product_id, sum(case when is_winner then 1 else -1 end) as score from product_hot_votes group by product_id) as votes on products.id = votes.product_id and votes.score < 0 order by votes.score limit #{limit}")
    render :list
  end
end
