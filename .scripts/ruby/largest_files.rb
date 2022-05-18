puts "How many files?"
no_of_files = gets.chomp.to_i
# Store a glob of filenames in the current directory in a variable
files = Dir.glob('*')

# Create an empty hash
files_with_sizes = {}

# Store each filename with its file size as keys and values in the hash, respectively
files.each do |file|
  files_with_sizes.store(file, File.size(file))
end

# Sort the hash on values in reverse order
files_sorted = files_with_sizes.sort_by { |_k, v| v }.reverse.first(no_of_files)
files_sorted.each do |f|
  puts "#{f[0]} => #{f[1]}"
end

