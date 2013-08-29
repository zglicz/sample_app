require 'spec_helper'

describe Movie do
  let(:user) { FactoryGirl.create(:user) }
  let(:device) { FactoryGirl.create(:device, user: user) }
  let(:movie) { FactoryGirl.create(:movie, device: device, user: user) }

  subject { movie }

  it { should respond_to(:name) }
  it { should respond_to(:folder_name) }
  it { should respond_to(:total_size) }
  it { should respond_to(:no_of_files) }
  it { should respond_to(:imdb_id) }
  it { should respond_to(:tagged) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:device_id) }
  it { should respond_to(:device) }


  its(:user) { should eq user }
  its(:device) { should eq device }

  it { should be_valid }

  describe "when folder name is not present" do
  	before { movie.folder_name = " " }
  	it { should_not be_valid }
  end

  describe "when user is not present" do
  	before { movie.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when device is not present" do
  	before { movie.device_id = nil }
  	it { should_not be_valid }
  end
end
