class RelationshipsController < ApplicationController
	before_action :authenticate_user!

	def follow_user
		current_user.follow(params[:user_id])
		if current_user.errors.present?
			render json: {message: current_user.errors.messages}, status: 422
		else
			render json: {message: "Followed Successfully"}
		end
	end

	def unfollow_user
		current_user.unfollow(params[:user_id])
		if current_user.errors.present?
			render json: {message: current_user.errors.messages}, status: 422
		else
			render json: {message: "UnFollowed Successfully"}
		end
	end


	def user_followers
		render json: {followers: current_user.followers}
	end

	def followers_tweets
		tweets = []
		current_user.followers.each do |user|
			tweets << {
				follower: user,
				tweets: user.tweets
			}
		end
		render json: {data: tweets}, status: 200
	end
end
