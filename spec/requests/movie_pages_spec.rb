require 'spec_helper'

describe "Movie pages" do
	subject { page }
	let!(:user) { FactoryGirl.create(:user) }
	let!(:device) { FactoryGirl.create(:device, user: user) }
	let!(:movie) { FactoryGirl.create(:movie, user: user, device: device) }

	before { sign_in user }

	describe "single movie page" do
		before { visit url_for([user, movie]) }

		it { should have_title(movie.name) }
		it { should have_link(device.name) }
		 
	end
end