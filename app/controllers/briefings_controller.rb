class BriefingsController < ApplicationController
	def create
		binding.pry
		user = @current_user
		briefing = Briefing.create(briefing_params)
		params[:interests].each do |interest_title|
			briefing.interests << Interest.find_by(title: interest_title)
		end
		
	end
end



private
 
def briefing_params
  params.require(:briefing).permit(:name, :description, :organization, :url, :interests)
end
