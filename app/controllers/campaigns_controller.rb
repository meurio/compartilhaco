class CampaignsController < ApplicationController
  respond_to :html, :json

  def index
    @campaigns = Campaign
      .unarchived
      .upcoming
      .order(:ends_at)
      .page(params[:page])
      .per(6)
  end

  def show
    @campaign = Campaign.find(params[:id])
    @last_spreaders = @campaign.campaign_spreaders.order(created_at: :desc).limit(5)
    @campaign_spreader = CampaignSpreader.new(campaign: @campaign)
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new(permitted_params)
    @campaign.user = current_user

    if @campaign.save
      respond_with @campaign, notice: 'Campanha criada!'
    else
      render :new
    end
  end

  def archive
    @campaign = Campaign.find(params[:id])
    @campaign.archive
    respond_with @campaign
  end

  def serve_image
    @campaign = Campaign.find(params[:id])
    data = open(@campaign.image.path).read
    send_data data, type: MIME::Types.type_for(@campaign.image.url).first.content_type, disposition: 'inline'
  end

  def permitted_params
    params.fetch(:campaign, {}).permit(:title, :description, :short_description, :image, :ends_at, :goal, :organization_id, :user_id, :share_link, :tweet, :share_title, :share_description, :share_image)
  end
end
