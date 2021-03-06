namespace :import do
  
  desc "Import instagram tags from file (direction: before (older) or after (newer)"
  task :instagram_tags_from_file, [:filename, :direction, :pages, :ban_filename] => [:environment] do |t, args|
    if Delayed::Job.where(:queue => 'import_instagram_tag').count == 0
      tags = File.read(args[:filename]).split(/$/)
      tags.each do |tag|
        InstagramMedia.delay(:queue => 'import_instagram_tag').populate_from_tag(tag, :direction => args[:direction], :pages => args[:pages], :ban_filename => args[:ban_filename])
      end
    end
  end
  
  desc "Import instagram by tag (direction: before (older) or after (newer)"
  task :instagram_tag, [:tag,:direction, :pages, :ban_filename] => [:environment] do |t, args|
    InstagramMedia.populate_from_tag(args[:tag], :direction => args[:direction], :pages => args[:pages], :ban_filename => args[:ban_filename])
  end
  
  desc "Import instagram by username"
  task :instagram_user, [:username] => [:environment] do |t, args|
    InstagramMedia.populate_from_user(args[:username])
  end
  
end