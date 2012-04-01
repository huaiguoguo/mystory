class AlbumsController < ApplicationController
  layout 'album'

  def index
    @albums = Album.where(["user_id = ?", @user.id]).order("created_at")
  end

  def show
    @album = Album.find(params[:id])
    if @album.user == @user
      @photos = Photo.where(["album_id = ?", params[:id]]).page(params[:page]).order("created_at DESC")
    else
      render text: t('page_not_found'), status: 404
    end
  end

  def new
    @album = Album.new
  end 

  def create
    @album = Album.new(params[:album])
    @album.user_id = session[:id]
    if @album.save
      redirect_to new_album_photo_path(@album), notice: t('create_succ')
    else
      render :new
    end
  end

  # GET /albums/1/edit
  def edit
    @album = Album.find(params[:id])
  end

  def update
    @album = Album.find(params[:id])
    if @album.update_attributes(params[:album])
      redirect_to album_path(@album), notice: t('update_succ')
    else
      render :edit
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :ok }
    end
  end

  def select_albums
    @albums = Album.where(["user_id = ?", session[:id]]).order("created_at")
    render layout: 'select_photos'
  end

  def select_photos
    @album = Album.find(params[:album_id])
    @photos = Photo.where(["album_id = ?", params[:album_id]]).page(params[:page]).order("created_at DESC")
    render layout: 'select_photos'
  end

end
