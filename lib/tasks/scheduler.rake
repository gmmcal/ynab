# frozen_string_literal: true

namespace :ynab do
  desc "TODO"
  task import: :environment do
    puts Importer.new(ENV.fetch("YNAB_TOKEN", nil)).process
  end
end
