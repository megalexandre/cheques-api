Rails.application.config.after_initialize do
  Rails.logger.info("🎯 Rail env: #{Rails.env}, RAILS_ENV=#{ENV['RAILS_ENV']}")
end
