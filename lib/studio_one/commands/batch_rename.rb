# frozen_string_literal: true

require "fileutils"
require "optparse"

module StudioOne
  module Commands
    class BatchRename < Command
      def initialize(config)
        super
        OptionParser.new do |parser|
          parser.banner = "This utility provides some helpful utilities for managing Studio One session files and mixdowns"
          parser.on("-sSOURCE", "--source=SOURCE", "Source directory") do |opt|
            @config.source_directory = opt
          end

          # parser.on("-sSUFFIX", "--suffix=SUFFIX", "Suffix all files with the source directory name") do |opt|
          #   @config.suffix = opt
          # end

          parser.on("-nBOOL", "--number-files=BOOL", TrueClass, "Number all files (i.e. 01 Song 1.mp3)") do |opt|
            @config.number_files = opt
          end

          parser.on("-tTARGET", "--target=TARGET", "Optional output directory; will output to parent of source directory otherwise") do |opt|
            @config.target_directory = opt
          end

          parser.on("-h", "--help", "Displays this help message") do
            puts parser
            exit
          end
        end.parse!
      end

      def run
        base_filename = File.basename(@config.source_directory_full)
        renames = Hash.new { |h, k| h[k] = [] }
        files = Dir.children(@config.source_directory_full).sort
        extension_path = @config.target_directory || @config.parent_directory

        files.each do |f|
          # Build rename rules
          if f.match?(/#{Regexp.quote(base_filename)} - \d{1,} (.*?)\.(.*)/) # Song
            # Make directory for extension if it does not already exist
            extension = File.extname(f).tr(".", "").upcase
            extension_dir = File.join(extension_path, extension)
            FileUtils.mkdir_p(extension_dir)
            number = @config.number_files ?
              "#{(renames[extension].length + 1).to_s.rjust(2, "0")} " :
              ""

            renames[extension].push(
              {
                old: f,
                new: f.gsub(
                  /#{Regexp.quote(base_filename)} - \d{1,} (.*?)\.(.*)/,
                  "#{number}\\1.#{extension.downcase}"
                )
              }
            )
          elsif f.match?(/#{Regexp.quote(base_filename)} - \d{1,}\..*/) # Not song
            # puts "Not song #{f}"
          else
            # puts "Idk: #{f}"
          end
        end

        if renames.any?
          renames.each do |(extension, rules)|
            rules.each do |rename|
              FileUtils.cp(
                File.join(@config.source_directory_full, rename[:old]),
                File.join(File.join(extension_path, extension), rename[:new])
              )
            end
          end
        end
      end
    end
  end
end
