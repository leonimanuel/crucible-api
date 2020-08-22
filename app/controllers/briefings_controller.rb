class BriefingsController < ApplicationController
	def create
		user = @current_user
		binding.pry
	end
end



private
 
def briefing_params
  params.require(:briefing).permit(:name, :description, :organization, :url, :interests)
end
