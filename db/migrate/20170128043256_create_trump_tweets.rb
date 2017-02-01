class CreateTrumpTweets < ActiveRecord::Migration[5.0]
  def change
    create_table :trump_tweets do |t|
      t.string :tweet_created
      t.string :tweet_text
      t.string :tweet_is_rt
      t.string :tweet_in_reply_to_screenname
      t.integer :tweet_fav_count
      t.integer :tweet_rt_count
      t.string :tweet_source
      t.string :tweet_id_string

      t.timestamps
    end
  end
end
