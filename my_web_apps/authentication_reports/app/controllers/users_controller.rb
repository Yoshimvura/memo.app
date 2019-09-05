# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @image = if @user.avatar.attached?
      @user.avatar.variant(resize: "100x100").processed
    else
      "azarashi.png"
    end
  end

  def following
    @user  = User.find(params[:id])
    @users = @user.followings
    render "show_follow"
  end

  def followers
    @user  = User.find(params[:id])
    @users = @user.followers
    render "show_follower"
  end

  def index
    @users = User.all
  end
end
