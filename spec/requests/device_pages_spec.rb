require 'spec_helper'

describe "DevicePages" do
  subject { page }
  let(:user) { FactoryGirl.create(:user) }
  let!(:device) { FactoryGirl.create(:device, user: user) }
  before { sign_in user }

  describe "devices list" do
  	before { visit user_devices_path(user) }
  	
  	it { should have_title("Devices") }
  	it { should have_content(device.name) }
  	it { should have_link("#{device.name}", href: user_device_path(user, device)) }

    describe "device creation" do
      describe "with invalid information" do
        it "should not create a new device" do
          expect { click_button "Add device" }.not_to change(Device, :count)
        end

        describe "error messages" do
          before { click_button "Add device" }
          it { should have_content("error") }
        end
      end

      describe "with valid information" do
        before do
          fill_in 'Name', with: "DEV"
          fill_in 'Description', with: "Coolest device eva"
        end
        it "should create a device" do
          expect { click_button "Add device"}.to change(Device, :count)
        end
      end
    end

  end

  describe "device page" do
    before { visit user_device_path(user, device) }

    it { should have_title("#{device.name}") }
    it { should have_link("Delete", href: user_device_path(user, device)) }

    it "should delete device when clicked" do
      expect { click_link("Delete") }.to change(Device, :count).by(-1)
    end

    describe "update device" do

      describe "with invalid data" do
        before do
          fill_in "device_name", with: " "
          click_button "Update device"
        end
        it { should have_content('error') }
        specify { expect(device.reload.name).not_to eq " " }
      end

      describe "with valid data" do
        let(:new_name) { "Passport" }
        let(:new_desc) { "Zebesciak" }
        before do
          fill_in "device_name",         with: new_name
          fill_in "device_description",  with: new_desc
          click_button "Update device"
        end

        it { should have_title(new_name) }
        it { should have_selector('div.alert.alert-success') }
        specify { expect(device.reload.name).to  eq new_name }
        specify { expect(device.reload.description).to eq new_desc }
      end
    end
  end
end
