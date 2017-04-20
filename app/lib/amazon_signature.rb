module AmazonSignature
  extend self

  def signature
    Base64.encode64(
        OpenSSL::HMAC.digest(
          OpenSSL::Digest.new('sha1'), ENV['AWS_SECRET_ACCESS_KEY'], self.policy)
      ).gsub("\n", "")
  end

  def policy
    Base64.encode64(self.policy_data.to_json).gsub("\n", "")
  end

  def policy_data
    {
      expiration: 10.hours.from_now.utc.iso8601,
      conditions: [
        ["starts-with", "$key", 'uploads/'],
        ["starts-with", "$x-requested-with", "xhr"],
        ["content-length-range", 0, 20.megabytes],
        ["starts-with", "$content-type", ""],
        {bucket: ENV['S3_BUCKET_NAME']},
        {region: ENV['S3_REGION']},
        {acl: 'public-read'},
        {success_action_status: "201"}
      ]
    }
  end

  def data_hash
    {
      :signature => self.signature,
      :policy => self.policy,
      :bucket =>ENV['S3_BUCKET_NAME'],
      :acl => 'public-read',
      :key_start => 'uploads/',
      :access_key => ENV['AWS_ACCESS_KEY_ID']
    }
  end
end
