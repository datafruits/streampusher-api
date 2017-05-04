class UploaderSignatureController < ApplicationController
  def index
    client = Aws::S3::Client.new(
      :region => 'us-east-1',
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET'],
    )
    signer = Aws::S3::Presigner.new client: client
    url = signer.presigned_url(:put_object, bucket: ENV['S3_BUCKET'],
                                            key: "#{@current_radio.container_name}/#{cleaned_filename(params[:name])}",
                                            expires_in: 10.hours.to_i,
                                            acl: "public-read")
    render json: { endpoint: url }
  end

  private
  def cleaned_filename filename
    filename.gsub /[^\w.-]/i, ''
  end
end
