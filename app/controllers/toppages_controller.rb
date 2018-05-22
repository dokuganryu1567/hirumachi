class ToppagesController < ApplicationController
  def index
    if logged_in?
      @user = current_user
      @post = current_user.posts.build
      @posts = Post.all.order('created_at DESC').page(params[:page])
      @my_posts = current_user.posts.order('created_at DESC').page(params[:page])
      @hav_markers = @posts.where.not(latitude: nil, longitude: nil)
      @hash = Gmaps4rails.build_markers(@hav_markers) do |post, marker|
        marker.lat post.latitude
        marker.lng post.longitude
        marker.infowindow post.shop_name
        marker.json({title: post.address})
      end
    end
  end
end
