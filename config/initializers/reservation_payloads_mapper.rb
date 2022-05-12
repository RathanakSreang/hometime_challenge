RESERVATION_PAYLOADS_MAPPER = YAML.load_file(
  Rails.root.join("config", "yml", "reservation_payloads.yml")
).with_indifferent_access
