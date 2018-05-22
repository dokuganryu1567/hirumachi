class PostsController < ApplicationController
  before_action :require_user_logged_in
  before_action :correct_user, only: [:destroy]

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    image_data = Magick::Image.read(@post.image.file.file)[0]
    exif_lat = image_data.get_exif_by_entry('GPSLatitude')[0][1].to_s.split(',').map(&:strip)
    exif_lng = image_data.get_exif_by_entry('GPSLongitude')[0][1].to_s.split(',').map(&:strip)
    @post.latitude = exif_lat.present? ? (Rational(exif_lat[0]) + Rational(exif_lat[1])/60 + Rational(exif_lat[2])/3600).to_f : nil
    @post.longitude = exif_lng.present? ? (Rational(exif_lng[0]) + Rational(exif_lng[1])/60 + Rational(exif_lng[2])/3600).to_f : nil
    if @post.save
      flash[:success] = 'メッセージを投稿しました'
      redirect_to current_user
    else
      @posts = current_user.posts.order('created_at DESC').page(params[:page])
      flash.now[:danger] = '投稿に失敗しました'
      render 'toppages/index'
    end
  end
  
  def edit
    @post = Post.find(params[:id])
  end
  
  def update
    @post = Post.find(params[:id])
    
    if @post.update(post_params)
      flash[:success] = '投稿が更新されました'
      redirect_to current_user
    else
      flash.now[:danger] = '投稿が更新されませんでした'
      render :edit
    end
  end
  
  def destroy
    @post.destroy
    flash[:success] = 'メッセージを削除しました'
    redirect_to current_user
  end
  
  private
  
  def post_params
    params.require(:post).permit(:congestion, :shop_name, :image, :latitude, :longitude)
  end
  
  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    unless @post
      redirect_to root_url
    end
  end
end
