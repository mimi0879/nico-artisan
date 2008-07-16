class ChatsController < ApplicationController
  # GET /chats
  # GET /chats.xml
  def index
    if params[:video_id]
      @video = Video.find_by_id(params[:video_id])
      @chats = @video.chats.paginate(:page => params[:page], :per_page => params[:per_page]) if @video
    else
      @chats = Chat.paginate(:order => 'id desc', :page => params[:page], :per_page => params[:per_page])
    end
    @chat = Chat.new # for search

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @chats }
    end
  end

  def search
    @video = Video.find_by_id(params[:video_id]) if params[:video_id]
    @chat = Chat.new(params[:chat])
    @chats = Chat.search(params)

    respond_to do |format|
      format.html { render :action => :index }
      format.xml  { render :xml => @chats }
    end
  end

  # GET /chats/1
  # GET /chats/1.xml
  def show
    @chat = Chat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @chat }
    end
  end

  # GET /chats/new
  # GET /chats/new.xml
  def new
    @chat = Chat.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chat }
    end
  end

  # GET /chats/1/edit
  def edit
    @chat = Chat.find(params[:id])
  end

  # POST /chats
  # POST /chats.xml
  def create
    # POST /videos/1/chats { update:true }
    if params[:update] == "true"
      @video = Video.find_by_id(params[:video_id])
      if @video
        size = @video.chats.size
        @video.dl_chats(Account.nv)
        @video.extract_chats
        added_size = @video.chats(true).size - size

        render :text => "#{added_size} new chats added."
      else
        render :text => "video not found"
      end
    else
      @chat = Chat.new(params[:chat])

      respond_to do |format|
        if @chat.save
          flash[:notice] = 'chat was successfully created.'
          format.html { redirect_to(@chat) }
          format.xml  { render :xml => @chat, :status => :created, :location => @chat }
        else
          format.html { render :action => "new" }
          format.xml  { render :xml => @chat.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # PUT /chats/1
  # PUT /chats/1.xml
  def update
    @chat = Chat.find(params[:id])

    respond_to do |format|
      if @chat.update_attributes(params[:chat])
        flash[:notice] = 'Chat was successfully updated.'
        format.html { redirect_to(@chat) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chat.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.xml
  def destroy
    @chat = Chat.find(params[:id])
    @chat.destroy

    respond_to do |format|
      format.html { redirect_to(chats_url) }
      format.xml  { head :ok }
    end
  end
end
