start = Time.now

require 'csv'

############ Human Input #############
## 									##
## 									##
	trump_tweets = true 			##
	bible_verses = true				##									
	mashup = true 					##
## 									##
## 									##
########## End Human Input ###########

##
#### Seed Trump Tweets
##
if trump_tweets == true
	csv = CSV.open( Rails.root.join('lib','seeds','trump_tweets.csv'), "r" ).to_a
	csv.each{|row|
		next if row[4] == "True"
		@hsh = { :tweet_created => row[5], :tweet_text => row[2], :tweet_is_rt => row[4], :tweet_in_reply_to_screenname => row[3], :tweet_fav_count => row[0] , :tweet_rt_count => row[6], :tweet_source => row[1], :tweet_id_string => row[-1] }
		TrumpTweet.create!( @hsh )
	}
	puts "App took #{Time.now-start} seconds to seed Trump Tweets"
end


##
#### Seed Bible Verses
##
if bible_verses == true
	csv = CSV.open( Rails.root.join('lib','seeds','bible_verses.csv'), "r" ).to_a
	csv.each{|row|
		next if row[4] == "True"
		@hsh = { :verse_num => row[0], :verse_text => row[1] }
		BibleVerse.create!( @hsh )
	}
	puts "App took #{Time.now-start} seconds to seed Trump Tweets + Bible Verses"
end

##
#### Mashup
##
if mashup == true

	@verses = BibleVerse.all.to_a.select!{ |record| record.verse_num.start_with?("03") }
	@tweets = TrumpTweet.all.to_a

	puts "============\n\n~~~~~~  Mashup Method 1 -- Colon separation ~~~~~~\n\n============"
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
	puts "App took #{(Time.now-start)/60} minutes to create 50 colon sep mashups"

	puts "============\n\n~~~~~~  Mashup Method 2 -- Semi-colon separated ~~~~~~\n\n============"
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
		Mashup.create!( :mashup_text => tweet_first[rand(tweet_first.length)].join )
		Mashup.create!( :mashup_text => verse_first[rand(verse_first.length)].join )
	end

end

puts "App took #{(Time.now-start)/60} minutes to seed 50 semi col Mashups"