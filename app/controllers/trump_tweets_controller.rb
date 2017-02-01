class TrumpTweetsController < ApplicationController
  before_action :set_trump_tweet, only: [:show, :edit, :update, :destroy]

  # GET /trump_tweets
  # GET /trump_tweets.json
  def index
    @trump_tweets = TrumpTweet.all
  end

  # GET /trump_tweets/1
  # GET /trump_tweets/1.json
  def show
  end

  # GET /trump_tweets/new
  def new
    @trump_tweet = TrumpTweet.new
  end

  # GET /trump_tweets/1/edit
  def edit
  end

  # POST /trump_tweets
  # POST /trump_tweets.json
  def create
    @trump_tweet = TrumpTweet.new(trump_tweet_params)

    respond_to do |format|
      if @trump_tweet.save
        format.html { redirect_to @trump_tweet, notice: 'Trump tweet was successfully created.' }
        format.json { render :show, status: :created, location: @trump_tweet }
      else
        format.html { render :new }
        format.json { render json: @trump_tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trump_tweets/1
  # PATCH/PUT /trump_tweets/1.json
  def update
    respond_to do |format|
      if @trump_tweet.update(trump_tweet_params)
        format.html { redirect_to @trump_tweet, notice: 'Trump tweet was successfully updated.' }
        format.json { render :show, status: :ok, location: @trump_tweet }
      else
        format.html { render :edit }
        format.json { render json: @trump_tweet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /trump_tweets/1
  # DELETE /trump_tweets/1.json
  def destroy
    @trump_tweet.destroy
    respond_to do |format|
      format.html { redirect_to trump_tweets_url, notice: 'Trump tweet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_trump_tweet
      @trump_tweet = TrumpTweet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def trump_tweet_params
      params.require(:trump_tweet).permit(:tweet_created, :tweet_text, :tweet_is_rt, :tweet_in_reply_to_screenname, :tweet_fav_count, :tweet_rt_count, :tweet_source, :tweet_id_string)
    end
end
