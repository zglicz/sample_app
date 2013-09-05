require 'csv'
require 'digest/sha1'

def process_folder_name(folder_name)
	forbidden_words = Regexp.union('dvd', 'rip', 'unrated', '720p', '1080p',
		'xvid', 'ac3', 'scr', 'bluray', 'limited', 'extended')
	forbidden_search = Regexp.new(forbidden_words.source, Regexp::IGNORECASE)
	res = folder_name.dup
	res.gsub!(/\./, ' ')
	first_pos = res.index(/[\[\]()]|(\d{4})/)
	res = res[0, first_pos].strip if first_pos
	words = res.split(' ')
	bad_index = words.find_index{ |word| word =~ forbidden_search }
	words = words[0, bad_index] if bad_index
	res = words.join(' ')
end


if ARGV.length == 0
	puts "usage: ruby #{$0} movies-directory"
	puts "example: ruby #{__FILE__} " + 'I:\filmy'
	exit
end

minimal_file_size_mb = 150

def movie?(file)
	File.size(file) / 2**20 > 150
end

def gen_sha1(contents)
	Digest::SHA1.hexdigest("#{contents}")
end

media_folder = ARGV[0]
json_filename = media_folder + '/' + 'summary.json'
csv_filename = media_folder + '/' + 'summary.csv'

movies = {}
folders = Dir.entries(media_folder).select {|f| File.directory?(File.join(media_folder, f))}
csv_summary = CSV.generate do |csv|
	header_row = ['folder_name', 'no_of_files', 'total_size']
	csv << header_row
	folders.each do |folder|
		next if folder == '.' or folder == '..'
		puts folder
		puts "\t#{process_folder_name(folder)}"
		media_files = Dir.glob(media_folder + "/" + folder + "/**/*")
		if media_files.empty?
			puts "\tERROR on: #{folder}\n"
			no_of_files = sum_of_sizes = 0
		else 
			files = media_files.select{ |f| movie? f }
			no_of_files = files.length
			sum_of_sizes = media_files.inject(0){ |sum, f| sum + File.size(f)} / 2**20
		end
		csv << [folder, no_of_files, sum_of_sizes]
	end
end

if !File.exist?(csv_filename) or gen_sha1(File.open(csv_filename).read) != gen_sha1(csv_summary)
	File.open(csv_filename, 'w') do |f|
		f.write(csv_summary)
	end
	puts 'created new summary file'
else
	puts 'look like summary was already up to date'
end
