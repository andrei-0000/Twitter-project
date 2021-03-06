class TweetsController < ApplicationController
  before_action :set_tweet, only: [:show, :edit, :update, :destroy, :like]

  # GET /tweets
  # GET /tweets.json
  def index
    @tweets = Tweet.all.order(created_at: :desc)
    @grouped_tweets = @tweets.group_by{ |t| t.created_at.strftime("%A, %B %-d, %Y")}
  end

  # GET /tweets/1
  # GET /tweets/1.json
  def show
  end

  # GET /tweets/new
  def new
    @tweet = Tweet.new
  end

  # GET /tweets/1/edit
  def edit
  end

  # POST /tweets
  # POST /tweets.json
  def create
    @tweet = Tweet.new(tweet_params)

    respond_to do |format|
      if @tweet.save
        format.html { redirect_to tweets_url, notice: 'Tweet was successfully created.' }
        format.json { render :show, status: :created, location: @tweet }
        if session[:created_ids].nil?
          session[:created_ids] = [@tweet.id]
        else 
          session[:created_ids].push(@tweet.id)
        end
      else
        format.html { render :new }
        format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tweets/1
  # PATCH/PUT /tweets/1.json
  # def update
  #   respond_to do |format|
  #     if @tweet.update(tweet_params)
  #       format.html { redirect_to @tweet, notice: 'Tweet was successfully updated.' }
  #       format.json { render :show, status: :ok, location: @tweet }
  #     else
  #       format.html { render :edit }
  #       format.json { render json: @tweet.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /tweets/1
  # DELETE /tweets/1.json
  def destroy
    if (session[:created_ids].nil?) || !(session[:created_ids].include? (@tweet.id)) 
      respond_to do |format|
      format.html { redirect_to tweets_url, alert: 'You are not allowed to delete this tweet' }
      format.json { head :no_content }
    end
    else
      @tweet.destroy
      respond_to do |format|
      format.html { redirect_to tweets_url, notice: 'Tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
    end
  end
 # LIKE/tweets/1
  # LIKE /tweets/1.json
  def like
    @tweet.likes += 1
    if @tweet.save
      respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render :show, status: :like, location: @tweet }
      end
    else
      respond_to do |format|
      format.html { render :new }
      format.json { render json: @tweet.errors, status: :unprocessable_entity }
      end
    end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tweet
      @tweet = Tweet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tweet_params
      params.require(:tweet).permit(:author, :content)
    end
end
