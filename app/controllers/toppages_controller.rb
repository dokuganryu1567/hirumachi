class ToppagesController < ApplicationController
  def index
    if logged_in?
      @post = current_user.posts.build

      #@hav_markers = Post.where.not(latitude: nil, longitude: nil)
      # @hash = Gmaps4rails.build_markers(@hav_markers) do |post, marker|
      #   marker.lat post.latitude
      #   marker.lng post.longitude
      #   marker.infowindow post.shop_name
      #   marker.json({title: post.address})
      # end
    end
  end
  
  def create
    # binding.pry
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
    @posts = []
    limit_time = Time.zone.now - 7200
    posts = Post.all
    posts.each do |post|
      post.latitude
      post.longitude
      p result = distance(post.latitude, post.longitude, @latitude, @longitude).to_f
      @posts << post if result < 4 && limit_time < post.created_at
    end
    # binding.pry
    @hav_markers = Post.where(id: @posts.pluck(:id)).where.not(latitude: nil, longitude: nil).order(created_at: :desc).to_a
    @hav_markers << Post.new(latitude: @latitude, longitude: @longitude, shop_name: "現在地")
    @hash = Gmaps4rails.build_markers(@hav_markers) do |post, marker|
      marker.lat post.latitude
      marker.lng post.longitude
      marker.infowindow post.shop_name
      marker.json({title: post.address})
    end
    
    render 'create', formats: 'js'
  end
  
  private
  
  def distance(lat1, lng1, lat2, lng2)
    # ラジアン単位に変換
    x1 = lat1.to_f * Math::PI / 180
    y1 = lng1.to_f * Math::PI / 180
    x2 = lat2.to_f * Math::PI / 180
    y2 = lng2.to_f * Math::PI / 180
    
    # 地球の半径 (km)
    radius = 6378.137
    
    # 差の絶対値
    diff_y = (y1 - y2).abs
    
    calc1 = Math.cos(x2) * Math.sin(diff_y)
    calc2 = Math.cos(x1) * Math.sin(x2) - Math.sin(x1) * Math.cos(x2) * Math.cos(diff_y)
    
    # 分子
    numerator = Math.sqrt(calc1 ** 2 + calc2 ** 2)
    
    # 分母
    denominator = Math.sin(x1) * Math.sin(x2) + Math.cos(x1) * Math.cos(x2) * Math.cos(diff_y)
    
    # 弧度
    degree = Math.atan2(numerator, denominator)
    
    # 大円距離 (km)
    return (degree * radius)
  end
end
