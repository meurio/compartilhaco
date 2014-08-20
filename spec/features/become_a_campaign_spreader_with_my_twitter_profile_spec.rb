require 'rails_helper'

feature "Become a campaign spreader with my Twitter profile", :type => :feature do
  let(:campaign) { Campaign.make! }
  let(:email){ "nicolas@trashmail.com" }
  let(:ip){ "192.168.0.1" }
  let(:twitter_uid){ "123" }

  before do
    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      provider: 'twitter',
      uid: twitter_uid
    })

    allow_any_instance_of(ActionDispatch::Request).to receive(:remote_ip).and_return(ip)
  end

  context "when I'm a new user" do
    let(:me){ User.find_by_email(email) }

    scenario "should create an user with my email" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me).to_not be_nil
    end

    scenario "should save my ip address" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me.ip).to be_eql(ip)
    end

    scenario "should create a Twitter profile for me" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me.twitter_profile).to_not be_nil
    end

    scenario "should save my Twitter profile uid" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me.twitter_profile.uid).to be_eql(twitter_uid)
    end

    scenario "should make me a campaign spreader" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(me.twitter_profile.campaign_spreaders).to have(1).campaign_spreader
    end

    scenario "should add a campaign spreader to the campaign" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(campaign.campaign_spreaders).to have(1).campaign_spreader
    end

    scenario "should redirect me to the campaign page" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(current_path).to be_eql(campaign_path(campaign))
    end

    scenario "should show me the alert box" do
      visit campaign_path(campaign)
      within("form.twitter-profile-campaign-spreader") do
        fill_in "campaign_spreader[timeline][user][email]", with: email
        click_button "twitter-profile-campaign-spreader-submit-button"
      end

      expect(page).to have_css(".alert-box")
    end
  end
end
