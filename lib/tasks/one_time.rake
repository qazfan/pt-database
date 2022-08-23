namespace :one_time do
  desc "TODO"
  task populate_owners: :environment do
    pets_to_save = Pet.all.select do |pet|
      new_owner = pet.fetch_data['custom_pet']['owner']
      raise unless new_owner
      pet.owner = new_owner
      puts "#{pet.name} currently belongs to #{pet.owner}"
      pet.save!
    end
  end

  task copy_profiles_to_users: :environment do
    Profile.all.each do |profile|
      u = profile.user
      next unless u
      u.description ||= profile.description
      u.neoname ||= profile.neoname
      u.save!
    end
  end
end
