namespace :update do
  desc "Update vip statuses and TOPs"
  task :vip => :environment do
    Order.update_pages
  end
end
