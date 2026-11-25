module LiquidsoapAuthentication
  private

  def liq_authorized?
    secret = Rails.configuration.x.liquidsoap.liq_secret
    secret.present? && ActiveSupport::SecurityUtils.secure_compare(secret, request.headers["liq-secret"].to_s)
  end
end
