require 'aws-sigv4'

class UploaderSignatureController < ApplicationController
  before_action :current_radio_required
  def index
    client = Aws::S3::Client.new(
      :region => 'us-east-1',
      :access_key_id => ENV['S3_KEY'],
      :secret_access_key => ENV['S3_SECRET'],
    )
    content_type = correct_mime_type

    signer = Aws::Sigv4::Signer.new(
                                    service: 's3',
                                    region: 'us-east-1',
                                    access_key_id: ENV['S3_KEY'],
                                    secret_access_key: ENV['S3_SECRET'],
                                    uri_escape_path: false,
                                   )

    # create presigned url for an object with bucket 'a-fancy-bucket' and key 'hello_world'
    url = signer.presign_url(
                             http_method: 'PUT',
                             url: "https://#{ENV['S3_BUCKET']}.s3.amazonaws.com/#{@current_radio.container_name}/#{cleaned_filename(params[:name])}",
                             headers: {
                               "Content-Type" => content_type,
                               "x-amz-acl" => "public-read"
                             },
                             body_digest: 'UNSIGNED-PAYLOAD',
                             expires_in: 10.hours.to_i,
                            )

    render json: { endpoint: url.to_s }
  end

  private
  def correct_mime_type
    if params[:type] == "audio/mp3"
      "audio/mpeg"
    else
      params[:type]
    end
  end

  def cleaned_filename filename
    filename.gsub /[^\w.-]/i, ''
  end
end
