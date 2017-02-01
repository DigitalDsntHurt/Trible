require 'test_helper'

class TrumpTweetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @trump_tweet = trump_tweets(:one)
  end

  test "should get index" do
    get trump_tweets_url
    assert_response :success
  end

  test "should get new" do
    get new_trump_tweet_url
    assert_response :success
  end

  test "should create trump_tweet" do
    assert_difference('TrumpTweet.count') do
      post trump_tweets_url, params: { trump_tweet: { tweet_created: @trump_tweet.tweet_created, tweet_fav_count: @trump_tweet.tweet_fav_count, tweet_id_string: @trump_tweet.tweet_id_string, tweet_in_reply_to_screenname: @trump_tweet.tweet_in_reply_to_screenname, tweet_is_rt: @trump_tweet.tweet_is_rt, tweet_rt_count: @trump_tweet.tweet_rt_count, tweet_source: @trump_tweet.tweet_source, tweet_text: @trump_tweet.tweet_text } }
    end

    assert_redirected_to trump_tweet_url(TrumpTweet.last)
  end

  test "should show trump_tweet" do
    get trump_tweet_url(@trump_tweet)
    assert_response :success
  end

  test "should get edit" do
    get edit_trump_tweet_url(@trump_tweet)
    assert_response :success
  end

  test "should update trump_tweet" do
    patch trump_tweet_url(@trump_tweet), params: { trump_tweet: { tweet_created: @trump_tweet.tweet_created, tweet_fav_count: @trump_tweet.tweet_fav_count, tweet_id_string: @trump_tweet.tweet_id_string, tweet_in_reply_to_screenname: @trump_tweet.tweet_in_reply_to_screenname, tweet_is_rt: @trump_tweet.tweet_is_rt, tweet_rt_count: @trump_tweet.tweet_rt_count, tweet_source: @trump_tweet.tweet_source, tweet_text: @trump_tweet.tweet_text } }
    assert_redirected_to trump_tweet_url(@trump_tweet)
  end

  test "should destroy trump_tweet" do
    assert_difference('TrumpTweet.count', -1) do
      delete trump_tweet_url(@trump_tweet)
    end

    assert_redirected_to trump_tweets_url
  end
end
