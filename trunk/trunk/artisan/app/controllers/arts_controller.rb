class ArtsController < ApplicationController
  in_place_edit_for :comment, :vpos
  in_place_edit_for :comment, :command
  in_place_edit_for :comment, :text
  in_place_edit_for :comment, :time
  in_place_edit_for :art, :title
  in_place_edit_for :art, :vid
  in_place_edit_for :art, :memo

  # GET /arts
  # GET /arts.xml
  def index
    @arts = Art.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @arts }
    end
  end

  # GET /arts/1
  # GET /arts/1.xml
  def show
    @art = Art.find(params[:id])
    @new_comment = Comment.new

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @art }
    end
  end

  # GET /arts/new
  # GET /arts/new.xml
  def new
    @art = Art.new

    if params[:video_id]
      @video = Video.find_by_id(params[:video_id])
      @art.vid = @video.vid if @video
    end
    if params[:i]
      @chats = Chat.find(:all, :conditions => ["id in (?)", params[:i]])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @art }
    end
  end

  # GET /arts/1/edit
  def edit
    @art = Art.find(params[:id])
    @new_comment = Comment.new
  end

  # POST /arts
  # POST /arts.xml
  def create
    @art = Art.new(params[:art])

    respond_to do |format|
      if @art.save
        @art.chats = params[:i]
        flash[:notice] = 'Art was successfully created.'
        format.html { redirect_to(@art) }
        format.xml  { render :xml => @art, :status => :created, :location => @art }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @art.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /arts/1
  # PUT /arts/1.xml
  def update
    @art = Art.find(params[:id])

    respond_to do |format|
      if @art.update_attributes(params[:art])
        flash[:notice] = 'Art was successfully updated.'
        format.html { redirect_to(@art) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @art.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /arts/1
  # DELETE /arts/1.xml
  def destroy
    @art = Art.find(params[:id])
    @art.destroy

    respond_to do |format|
      format.html { redirect_to(arts_url) }
      format.xml  { head :ok }
    end
  end

  # POST /arts/1/nicopost { vid:"sm9", vpos:"2:13" }
  def nicopost
    @art = Art.find(params[:id])
    return unless @art and params[:vid]
    @art.nicopost(params[:vid], params[:vpos])
    render :text => "<a href=\"http://www.nicovideo.jp/watch/#{params[:vid]}\">done.</a>" # FIXME:XSS
  end
end
