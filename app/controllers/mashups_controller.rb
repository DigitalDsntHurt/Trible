class MashupsController < ApplicationController
  before_action :set_mashup, only: [:show, :edit, :update, :destroy]
  http_basic_authenticate_with name: ENV['MASHUPS_ADMIN_UNAME'], password: ENV['MASHUPS_ADMIN_PASS']
  # GET /mashups
  # GET /mashups.json
  def index
    @mashups = Mashup.all
  end

  # GET /mashups/1
  # GET /mashups/1.json
  def show
  end

  # GET /mashups/new
  def new
    @mashup = Mashup.new
  end

  # GET /mashups/1/edit
  def edit
  end

  # POST /mashups
  # POST /mashups.json
  def create
    @mashup = Mashup.new(mashup_params)

    respond_to do |format|
      if @mashup.save
        format.html { redirect_to @mashup, notice: 'Mashup was successfully created.' }
        format.json { render :show, status: :created, location: @mashup }
      else
        format.html { render :new }
        format.json { render json: @mashup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /mashups/1
  # PATCH/PUT /mashups/1.json
  def update
    respond_to do |format|
      if @mashup.update(mashup_params)
        format.html { redirect_to @mashup, notice: 'Mashup was successfully updated.' }
        format.json { render :show, status: :ok, location: @mashup }
      else
        format.html { render :edit }
        format.json { render json: @mashup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /mashups/1
  # DELETE /mashups/1.json
  def destroy
    @mashup.destroy
    respond_to do |format|
      format.html { redirect_to mashups_url, notice: 'Mashup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def set_tweet_to_true
    mashup = Mashup.find(params[:id])
    mashup.update(tweet?: true)
    redirect_to :back
  end

  def generate_new_mashups
    @verses = BibleVerse.all.to_a.select!{ |record| record.verse_num.start_with?(rand(1..66).to_s) }
    @tweets = TrumpTweet.all.to_a

    before_sc_verses = []
    after_sc_verses = []
    # Select verses & tweets which include ";" ";" "!" "?" "--" "and"
    verses_w_punc = @verses.select{|v| v.verse_text.include?(";") or v.verse_text.include?(":") or v.verse_text.include?("!") or v.verse_text.include?("?") or v.verse_text.include?("--") } # or v.verse_text.include?(" and ")
    tweets_w_punc = @tweets.select{ |tw| tw.tweet_text.include?(";") or tw.tweet_text.include?(":") or tw.tweet_text.include?("!") or tw.tweet_text.include?("?") or tw.tweet_text.include?("--") } # or tw.tweet_text.include?(" and ")
    
    # Get fronts & backs of TWEETS
    before_first_punc_tweets = []
    after_last_punc_tweets = []
    tweets_w_punc.each{|tw|
      # Fronts
      @first_punc_index = [ tw.tweet_text.index(":"), tw.tweet_text.index(";"), tw.tweet_text.index("!"), tw.tweet_text.index("?"), tw.tweet_text.index("--"), tw.tweet_text.index(" and ") ].reject{|item| item == nil }.sort.first
      @before_first_punc = tw.tweet_text[0..@first_punc_index]
    before_first_punc_tweets << @before_first_punc unless @before_first_punc == nil or @before_first_punc.length < 5 or @before_first_punc.length > 85
    # Backs
    @last_punc_index = [ tw.tweet_text.index(":"), tw.tweet_text.index(";"), tw.tweet_text.index("!"), tw.tweet_text.index("?"), tw.tweet_text.index("--"), tw.tweet_text.index(" and ") ].reject{|item| item == nil }.sort[-1]
      @after_last_punc = tw.tweet_text[(@last_punc_index+1)..-1].strip
      after_last_punc_tweets << @after_last_punc unless @after_last_punc == nil or @after_last_punc.include?("//") or @after_last_punc.length < 5 or @after_last_punc.length > 85
    }

    # Get fronts & backs of VERSES
    before_first_punc_verses = []
    after_last_punc_verses = []
    verses_w_punc.each{|v|
      # Fronts
      @first_punc_index = [ v.verse_text.index(":"), v.verse_text.index(";"), v.verse_text.index("!"), v.verse_text.index("?"), v.verse_text.index("--"), v.verse_text.index(" and ") ].reject{|item| item == nil }.sort.first
      @before_first_punc = v.verse_text[0..@first_punc_index]
    before_first_punc_verses << @before_first_punc unless @before_first_punc == nil or @before_first_punc.length < 5 or @before_first_punc.length > 85
    # Backs
    @last_punc_index = [ v.verse_text.index(":"), v.verse_text.index(";"), v.verse_text.index("!"), v.verse_text.index("?"), v.verse_text.index("--"), v.verse_text.index(" and ") ].reject{|item| item == nil }.sort[-1]
      @after_last_punc = v.verse_text[(@last_punc_index+1)..-1].strip
    after_last_punc_verses << @after_last_punc unless @after_last_punc == nil or @after_last_punc.length < 5 or @after_last_punc.length > 85
    }

    tweet_first = before_first_punc_tweets.product(after_last_punc_verses)#.reject!{|mash| mash.join.strip.length > 140}
    verse_first = before_first_punc_verses.product(after_last_punc_tweets)#.reject!{|mash| mash.join.strip.length > 140}

    100.times do 
      tf = tweet_first[rand(0..tweet_first.length)]
      if tf[0][-1] == "!" or tf[0][-1] == "?"
        newmash = tf[0] + " " + tf[1].capitalize
      else
        newmash = p tf[0] + " " + tf[1]
      end
      Mashup.create!(:mashup_text => newmash.gsub("\"","")) unless newmash == nil or newmash.length > 140

      vf = verse_first[rand(0..verse_first.length)]
      if vf[0][-1] == "!" or vf[0][-1] == "?"
        newmash = p vf[0] + " " + vf[1].capitalize
      else 
        newmash = p vf[0] + " " + vf[1]
      end
      Mashup.create!(:mashup_text => newmash.gsub("\"","")) unless newmash == nil or newmash.length > 140


      ###### ###### ###### 

      @verses = BibleVerse.all.to_a.select!{ |record| record.verse_num.start_with?(rand(1..66).to_s) }
      @tweets = TrumpTweet.all.to_a

      # Separate verses by colon and store the short ones
      before_colon_verses = []
      after_colon_verses = []
      # Select verses w/ colons
      verses_w_colons = @verses.select{|v| v.verse_text.include?(":") }
      verses_w_colons.each{|v| 
        @colon_index = v.verse_text.index(":")
        @before_colon = v.verse_text[0..@colon_index]
        @after_colon = v.verse_text[(@colon_index+1)..-1]
        # Only add the short ones!
        before_colon_verses << @before_colon.gsub("&amp;","&") if @before_colon.length < 91
        after_colon_verses << @after_colon.gsub("&amp;","&") if @after_colon.length < 91
      }

      # Separate tweets by colon and store the short ones
      before_colon_tweets = []
      after_colon_tweets = []
      @tweets_with_colons = @tweets.select{ |tw| tw.tweet_text.include?(":") }#.reject{|t|  t.tweet_text.include?("@") }.reject{|t|  t.tweet_text.include?("http://") }
      @tweets_with_colons.each{|tw|
        @colon_index = tw.tweet_text.index(":")
        @before_colon = tw.tweet_text[0..@colon_index]
        @after_colon = tw.tweet_text[(@colon_index+1)..-1]
        # Only add the short ones!
        before_colon_tweets << @before_colon.gsub("&amp;","&") if @before_colon.length < 51
        after_colon_tweets << @after_colon.gsub(/(?:f|ht)tps?:\/[^\s]+/,"").gsub("&amp;","&") if @after_colon.gsub(/(?:f|ht)tps?:\/[^\s]+/,"").length < 51 #&& @after_colon.length > 17
      }

      tweet_first = before_colon_tweets.reject{|t|  t.length < 33 }.map{|t| t.gsub(" http:", " ") }.map{|t| t.gsub("https:", ": ") }.map{|t| t.gsub("\"","") }.product(after_colon_verses.reject{|t|  t.length < 33 }.map{|t| t.gsub(" http:", " ") }.map{|t| t.gsub("https:", ": ") }.map{|t| t.gsub("\"","") })
      verse_first = before_colon_verses.reject{|t|  t.length < 33 }.map{|t| t.gsub(" http:", " ") }.map{|t| t.gsub("https:", ": ") }.map{|t| t.gsub("\"","") }.product(after_colon_tweets.reject{|t|  t.length < 33 }.map{|t| t.gsub(" http:", " ") }.map{|t| t.gsub("https:", ": ") }.map{|t| t.gsub("\"","") })

      50.times do 
        Mashup.create!( :mashup_text => tweet_first[rand(tweet_first.length)].join )
        Mashup.create!( :mashup_text => verse_first[rand(verse_first.length)].join )
      end
      
      ###### ###### ###### 

      @verses = BibleVerse.all.to_a.select!{ |record| record.verse_num.start_with?(rand(1..66).to_s) }
      @tweets = TrumpTweet.all.to_a

      # Separate verses by question mark and store the short ones
      before_sc_verses = []
      after_sc_verses = []
      # Select verses w/ colons
      verses_w_scs = @verses.select{|v| v.verse_text.include?(";") }

      verses_w_scs.each{|v| 
        @sc_index = v.verse_text.index(";")
        @before_sc = v.verse_text[0..@sc_index]
        @after_sc = v.verse_text[(@sc_index+1)..-1]
        # Only add the short ones!
        before_sc_verses << @before_sc.gsub("&amp;","&") if @before_sc.length < 91 && @after_sc.length > 5
        after_sc_verses << @after_sc.gsub("&amp;","&") if @after_sc.length < 91 && @after_sc.length > 5
      }

      # Separate tweets by colon, semi-colon or dash and store the short ones
      before_mixed_punc_tweets = []
      after_mixed_punc_tweets = []
      @tweets_with_mixed_punc = @tweets.select{ |tw| tw.tweet_text.include?(":") or tw.tweet_text.include?(";") or tw.tweet_text.include?(" - ") or tw.tweet_text.include?("--")}#.reject{|t|  t.tweet_text.include?("@") }.reject{|t|  t.tweet_text.include?("http://") }
      @tweets_with_mixed_punc.each{|tw|
        @mixed_punc_indices = [ tw.tweet_text.index(":"), tw.tweet_text.index(";"), tw.tweet_text.index(" - "), tw.tweet_text.index("--") ].reject{|item| item == nil }.sort
        @first_punc_index = @mixed_punc_indices[0]
        @last_punc_index = @mixed_punc_indices[-1]
        @before_first_punc = tw.tweet_text[0..@first_punc_index].gsub("http:","").strip
        @after_last_punc = tw.tweet_text[(@last_punc_index+1)..-1].gsub("\n"," ").gsub(/(?:f|ht)tps?:\/[^\s]+/, '')

        before_mixed_punc_tweets << @before_first_punc.gsub("&amp;","&") if @before_first_punc.length < 51 unless @before_first_punc.length < 5 or @before_first_punc.start_with?("\"@") #if @before_mixed_punc.length < 51
        after_mixed_punc_tweets << @after_last_punc.gsub("&amp;","&") unless @after_last_punc.start_with?("://") or @after_last_punc.start_with?("//") or @after_last_punc.length < 5 or @before_first_punc.start_with?("\"@") or @before_first_punc.start_with?("@")#.gsub(/(?:f|ht)tps?:\/[^\s]+/,"") #if @after_colon.gsub(/(?:f|ht)tps?:\/[^\s]+/,"").length < 51 #&& @after_colon.length > 17
      }

      tweet_first = before_mixed_punc_tweets.product(after_sc_verses)
      verse_first = before_sc_verses.product(after_mixed_punc_tweets)

      50.times do 
        #p tweet_first[rand(tweet_first.length)].join
        #p verse_first[rand(verse_first.length)].join
        Mashup.create!( :mashup_text => tweet_first[rand(tweet_first.length)].join.gsub("\"","").gsub(";-"," -") )
        Mashup.create!( :mashup_text => verse_first[rand(verse_first.length)].join.gsub("\"","").gsub(";-"," -") )
      end


      redirect_to(:action => "index") and return
    end

  end #generate_new_mashups

  def clear_unqueued_mashups
    Mashup.where(tweet?: false, tweeted?: false).delete_all
    redirect_to :back
  end

  def clear_all_mashups
    Mashup.delete_all
    redirect_to :back
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mashup
      @mashup = Mashup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def mashup_params
      params.require(:mashup).permit(:index)
    end

end
