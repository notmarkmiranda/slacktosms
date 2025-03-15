class SignalWireService
  def initialize
    @client = Signalwire::REST::Client.new(
      ENV["SIGNALWIRE_PROJECT_ID"],
      ENV["SIGNALWIRE_TOKEN"],
      signalwire_space_url: ENV["SIGNALWIRE_SPACE_URL"]
    )
  end

  def send_sms(to:, from:, body:)
    @client.messages.create(
      to: to,
      from: from,
      body: body
    )
  rescue Signalwire::REST::RequestError => e
    Rails.logger.error("SignalWire SMS Error: #{e.message}")
    raise
  end
end
