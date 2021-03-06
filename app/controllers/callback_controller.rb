class CallbackController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def webhook
    CallbackWebhookJob.perform_later(
      shop_domain: shop.shopify_domain,
      callback: params[:callback],
      topic: params[:topic]
    )

    head :ok
  rescue => e
    Rails.logger.error(e)
    head :ok
  end

  private

  def shop
    @shop ||= Shop.find(params[:shop_id])
  end
end
