API_ERRORS = YAML.load_file(
  Rails.root.join("config", "yml", "api_error_codes.yml")
).with_indifferent_access
