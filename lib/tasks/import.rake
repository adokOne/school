namespace :import do
  translations = {}
  desc "Import i18n"
  task :i18n => :environment do
    data = []
    Tolk::Phrase.all.each do |item|
      data << {key: item.key, value: I18n.t(item.key)}
    end
    Translation.create(data)
  end
end
