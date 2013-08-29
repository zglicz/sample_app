require 'spec_helper'

describe Device do
  let(:user) { FactoryGirl.create(:user) }
  before do
  	@device = user.devices.build(name: "Numero uno", description: "Najcudniejszy")
  end

  subject { @device }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:movies) }

  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @device.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when name is not present" do
  	before { @device.name = " " }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @device.name = "a" * 11 }
    it { should_not be_valid }
  end

  describe "movie associations" do
    before { @device.save }
    let!(:movie) { FactoryGirl.create(:movie, user: user, device: @device) } 

    it "should have movie added" do
      expect(@device.movies).to include(movie)
    end

    it "should destroy associated movies" do
      movies = @device.movies.to_a
      @device.destroy
      expect(movies).not_to be_empty
      movies.each do |movie|
        expect(Movie.where(id: movie.id)).to be_empty
      end
    end
  end
end
