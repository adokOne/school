require_dependency "b1_admin/application_controller"

module B1Admin
  class AdminController < ApplicationController
  	def index
  		@reviews_count = Review.count
      @reviews_unaproved__count = Review.not_active.count
      @pages_unactive_count = Page.unactive.by_today.count
      @pages_count = Page.count
      @users_count = ::User.count
      @users_count_this_month = ::User.by_this_month.count
  	end

  	def login
  		@login = B1Admin::Login.new
  		render layout: "b1_admin/login"
  	end
  end
end
