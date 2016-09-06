StatsD.backend = StatsD::Instrument::Backends::UDPBackend.new(
  "localhost:8125",
  :datadog,
)

if Rails.env.staging?
  StatsD.prefix = "staging"
end
