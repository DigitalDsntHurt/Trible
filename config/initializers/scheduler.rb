

scheduler = Rufus::Scheduler.new
scheduler.every '90s', :first_in => '1s' do
	# Get tweets from tweet queue
	queue = Mashup.all.where(tweet?: true, tweeted?: false)

	# Initiate Twitter client
	client = Twitter::REST::Client.new do |config|
		config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
		config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
		config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
		config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
	end

	# Get a random tweet from the queue
	rand_mashup = queue[rand(queue.length)]
	# 
	if rand_mashup.mashup_text.length <= 140
		# tweet it
		client.update( rand_mashup.mashup_text )
		# mark it as tweeted in db
		rand_mashup.update!(tweeted?: true)
	end

end # Scheduler
