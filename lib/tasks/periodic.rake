namespace :periodic do
  task check_owners: :environment do
    pets_to_destroy = Pet.all.select do |pet|
      new_owner = pet.fetch_data['custom_pet']['owner']
      if new_owner && new_owner != pet.owner
        puts "Destroying #{pet.name}: Moved from #{pet.owner} to #{new_owner}"
        pet.destroy!
      end
    end
  end
end
