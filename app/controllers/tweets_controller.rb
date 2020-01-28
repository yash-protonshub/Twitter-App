class TweetsController < ApplicationController
	before_action :authenticate_user!

	def index
		render json:{tweets: current_user.tweets}, status: 200
	end

	def create
		tweet = current_user.tweets.new(tweet_params)
		if tweet.save
			render json:{message: "Tweet created successfully", tweet: tweet}, status: 200
		else
			render json:{message: "Some error in creating Tweet"}, status: 422
		end
	end

	def destroy
		tweet = current_user.tweets.find_by_id(params[:id])
		if tweet.present? && tweet.destroy
			render json:{message: "Tweet deleted successfully"}, status: 200
		else
			render json:{message: "Some error in deleting Tweet"}, status: 422
		end
	end

	def show
		tweet = current_user.tweets.find_by_id(params[:id])
		if tweet.present?
			render json:{tweet: tweet.as_json.merge!({user: tweet.user})}, status: 200
		else
			render json:{message: "Some error in showing Tweet"}, status: 422
		end
	end

	def user_profile
		render json:{user_details: current_user, followers: current_user.followers, following: following(current_user) }, status: 200	
	end

	def followers_tweets
		tweets = []
		current_user.followers.each do |user|
			tweets << {
				user: user,
				tweets: user.tweets
			}
		end
	end

	private

	def following user
		user.follower_relationships.where(follower_id: user.id)
	end

	def tweet_params
		params.require(:tweet).permit(:title, :text)
	end
end
