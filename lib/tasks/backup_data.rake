desc "backup data"
task :backup_data  => :environment do
  backup_path = "#{ENV['HOME']}/backup_data/message"
  system("mkdir -p #{backup_path}")
  Dir.open(backup_path).each do |file|
    next unless file =~ /\.dump$/
    file_date = file[/(.+)\.dump/,1]
    # 删除五天以前的备份数据
    File.delete(File.join(backup_path,file)) if ( Time.now.to_date - Time.parse(file_date).to_date).to_i > 1
  end
  File.open("#{backup_path}/backup.log","a+") do |io|
    start_time = Time.now
    io.puts("#{start_time} 备份开始")
    system("pg_dump -O -Fc -f #{backup_path}/#{Time.now.strftime("%Y-%m-%d_%H:%M")}.dump -d development_messages_wall")
    end_time = Time.now
    io.puts("#{end_time} 备份结束 花费#{(end_time - start_time).to_i} s\n\n\n\n")
  end
end
