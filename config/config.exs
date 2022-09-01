import Config

if File.exists?("config/config.secret.exs") do
  import_config "config.secret.exs"
end

config :stripity_stripe, api_key: "sk_test_51KVeNwDmYNhhsoWQdQHyHnAIAnJ5DGnLnXdntvgcxWNl1QmyycUtdsqe6wQKLPwqmymfVcoDcNBsmK8qSYZ4WECD00gRw9JlMB"
