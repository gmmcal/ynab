# frozen_string_literal: true

namespace :ynab do
  desc 'TODO'
  task import: :environment do
    puts Importer.new(ENV['YNAB_TOKEN']).process
  end
end
