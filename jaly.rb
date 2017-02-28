require 'optparse'
require './lib/jaly_libs'

cmd_opts = {}
OptionParser.new do |op|
  op.on('-u', '--uri', 'Force URI mode') { |v|
    cmd_opts[:mode] = :uri
  }
  op.on('-s', '--search', 'Force Search mode') { |v|
    cmd_opts[:mode] = :search
  }
  op.on('-i', '--interactive', 'Force Interactive mode') { |v|
    cmd_opts[:mode] = :interactive
  }
  op.parse! ARGV
end

unless cmd_opts[:mode]
  if ARGV[0].nil?
    cmd_opts[:mode] = :interactive
  elsif ARGV[0] =~ /\Ahttps?:/ or File.exist?(ARGV[0])
    cmd_opts[:mode] = :uri
    cmd_opts[:uri] = ARGV[0]
  else
    cmd_opts[:mode] = :search
    cmd_opts[:keyword] = ARGV[0]
  end
end

case cmd_opts[:mode]
when :uri
  if lyrics = Jaly.load(cmd_opts[:uri])&.lyrics
    puts "#{lyrics.title} - #{lyrics.meta[:artist]}"
    puts lyrics.meta
    puts '-'*32
    puts lyrics.text
  else
    puts 'Failed to load lyrics'
  end
when :search
  puts 'incomplete'
when :interactive
  puts 'Interactive mode.. initializing..'
  puts 'incomplete'
end
