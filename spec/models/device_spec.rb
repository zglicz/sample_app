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
end
